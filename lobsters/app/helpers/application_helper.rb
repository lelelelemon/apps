module ApplicationHelper
  MAX_PAGES = 15

  def break_long_words(str, len = 30)
    safe_join(str.split(" ").map{|w|
      if w.length > len
        safe_join(w.split(/(.{#{len}})/), "<wbr>".html_safe)
      else
        w
      end
    }, " ")
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class=\"flash-error\">\n"
      object.errors.full_messages.each do |error|
        html << error << "<br>"
      end
      html << "</div>\n"
    end

    raw(html)
  end

  def page_numbers_for_pagination(max, cur)
    if max <= MAX_PAGES
      return (1 .. max).to_a
    end

    pages = (cur - (MAX_PAGES / 2) + 1 .. cur + (MAX_PAGES / 2) - 1).to_a

    while pages[0] < 1
      pages.push (pages.last + 1)
      pages.shift
    end

    while pages.last > max
      if pages[0] > 1
        pages.unshift (pages[0] - 1)
      end
      pages.pop
    end

    if pages[0] != 1
      if pages[0] != 2
        pages.unshift "..."
      end
      pages.unshift 1
    end

    if pages.last != max
      if pages.last != max - 1
        pages.push "..."
      end
      pages.push max
    end

    pages
  end

  def time_ago_in_words_label(time, options = {})
    strip_about = options.delete(:strip_about)
    ago = time_ago_in_words(time, options)

    if strip_about
      ago.gsub!(/^about /, "")
    end

    raw(label_tag(nil, ago, :title => time.strftime("%F %T %z")))
  end
  def show_comment(comment, first)
    s = ""
    s << "<div id=comment_=#{ comment.short_id} data-shortid=#{comment.short_id if comment.persisted?} class=comment#{comment.current_vote ? (comment.current_vote[:vote] == 1 ? "upvoted" : "downvoted") : ''} "
      s << "#{comment.highlighted ? 'highlighted' : ''}"
      s << "#{comment.score <= 0 ? "negative" : ""}"
      s << "#{ comment.score <= -1 ? "negative_1" : "" } "
      s << "#{comment.score <= -3 ? "negative_3" : "" } "
      s << "#{comment.score <= -5 ? "negative_5" : "" } >"
      if !comment.is_gone?
        s << "<div class='voters'>"
        if @user
          s << "<a class='upvoter'></a>"
        else
          s << "link_to '', login_path, :class => 'upvoter'"
        end
          s << "<div class='score'>#{comment.score}</div>"
        if @user && @user.can_downvote?(comment)
          s << "<a class='downvoter'></a>"
        else
          s << "<span class='downvoter downvoter_stub'></span>"
        end
        s << "</div>"
      end
      s << '<div class="details">'
      s << '<div class="byline">'
        s <<  "<a name='c_#{comment.short_id}'></a>"
  
        if @user
          s << '<a class="comment_folder"></a>'
        end
        if @user && @user.show_avatars?
          s << "<a href='/u/#{comment.user.username}'><img"
          s << "src='comment.user.avatar_url(16)' class='avatar'></a>"
        end
  
        if defined?(was_merged) && was_merged
          s << "<span class='merge'></span>"
        end 
  
        s << "<a href='/u/#{comment.user.username}' "
        if  !comment.user.is_active? 
          s << 'class="inactive_user"'
        elsif comment.user.is_new? 
          s << 'class="new_user"'
        end
        s << ">#{comment.user.username}</a> " 
  
        if comment.hat 
          s << "#{comment.hat.to_html_label} "
        end
  
        if comment.previewing
          s << "previewed"
          s << "just now"
        else
          if comment.has_been_edited? 
           s << "edited"
          elsif comment.is_from_email? 
           s << "e-mailed"
          end
          s << "#{time_ago_in_words_label((comment.has_been_edited? ?
            comment.updated_at : comment.created_at), :strip_about => true)}  ago"
        end
  
        if  !comment.previewing 
          s << '|'
          s << "<a href = #{comment.url} >link</a>"
  
          if  comment.is_editable_by_user?(@user) 
            s << '|'
            s << "<a class='comment_editor'>edit</a>"
          end
  
          if  comment.is_gone? && comment.is_undeletable_by_user?(@user) 
            s << '|'
            s << '<a class="comment_undeletor">undelete</a>'
          elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
            s << '|'
            s << '<a class="comment_deletor">delete</a>'
          end
  
          if  @user && !comment.story.is_gone? && !comment.is_gone? 
              s << '|'
              s << '<a class="comment_replier" unselectable="on">reply</a>'
          end
  
          s << '<span class="reason">'
            if  comment.downvotes > 0 &&
            ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
            @user.try("is_moderator?")) 
              s <<  "|#{comment.vote_summary.downcase} "
            elsif comment.current_vote && comment.current_vote[:vote] == -1 
              s << '| -1'
              s << "#{Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase} "
            end
          s << '</span>'
        end
  
        if  defined?(show_story) && show_story 
          s << "| on:"
          s << "<a href= #{comment.story.comments_path}>  #{comment.story.title}"
          s <<  "</a>"
        end
      s << "</div>"
      s << " <div class='omment_text'>"
        if  comment.is_gone? 
          s << "<p>"
          s << '<span class="na">'
          s << "[#{comment.gone_text} ]"
          s << "</span>"
          s << "</p>"
        else
          s << "#{raw comment.markeddown_comment} "
        end
        s << "</div>"
      s << "</div>"
      
    s << "</div>"
    s.html_safe
  end
end

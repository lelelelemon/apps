import { ajax } from 'discourse/lib/ajax';
import ModalFunctionality from 'discourse/mixins/modal-functionality';
import { escapeExpression } from 'discourse/lib/utilities';
import { extractError } from 'discourse/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend(ModalFunctionality, {

  @computed('accountEmailOrUsername', 'disabled')
  submitDisabled(accountEmailOrUsername, disabled) {
    return Ember.isEmpty((accountEmailOrUsername || '').trim()) || disabled;
  },

  onShow() {
    if ($.cookie('email')) {
      this.set('accountEmailOrUsername', $.cookie('email'));
    }
  },

  actions: {
    submit() {
      if (this.get('submitDisabled')) return false;

      this.set('disabled', true);

      ajax('/session/forgot_password', {
        data: { login: this.get('accountEmailOrUsername').trim() },
        type: 'POST'
      }).then(data => {
        const escaped = escapeExpression(this.get('accountEmailOrUsername'));
        const isEmail = this.get('accountEmailOrUsername').match(/@/);
        let key = 'forgot_password.complete_' + (isEmail ? 'email' : 'username');
        let extraClass;

        if (data.user_found === true) {
          key += '_found';
          this.set('accountEmailOrUsername', '');
          bootbox.alert(I18n.t(key, {email: escaped, username: escaped}));
          this.send("closeModal");
        } else {
          if (data.user_found === false) {
            key += '_not_found';
            extraClass = 'error';
          }

          this.flash(I18n.t(key, {email: escaped, username: escaped}), extraClass);
        }
      }).catch(e => {
        this.flash(extractError(e), 'error');
      }).finally(() => {
        setTimeout(() => this.set('disabled', false), 1000);
      });

      return false;
    }
  }

});

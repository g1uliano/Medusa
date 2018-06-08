<%inherit file="/layouts/main.mako"/>
<%!
from medusa import app
%>
<%block name="scripts">
<script>
window.app = {};
const startVue = () => {
    window.app = new Vue({
        el: '#vue-wrap',
        data() {
            return {
                defaultPage: '${sbDefaultPage}',
                currentPid: '${sbPID}',
                checkIsAlive: undefined,
                restartTimer: undefined,
                // undefined = hidden, null = loading, true/false = result
                status: {
                    shutdown: null,
                    restart: undefined,
                    refresh: undefined,
                }
            };
        },
        mounted() {
            this.restartTimer = setTimeout(this.restartFailed, 60000);
            this.checkIsAlive = setTimeout(this.restartHandler, 2000);
        },
        methods: {
            async restartHandler() {
                const { status, defaultPage, restartTimer } = this;

                let data;
                try {
                    // @TODO: Move to API
                    data = await $.get({
                        url: 'home/is_alive/',
                        dataType: 'jsonp'
                    });
                } catch (error) {
                    status.shutdown = true;
                    status.restart = null;
                }

                if (data) {
                    if (data.msg.toLowerCase() === 'nope') {
                        // If it's still initializing then just wait and try again
                    } else if (this.currentPid === '' || data.msg === this.currentPid) {
                        status.shutdown = true;
                        status.restart = null;
                        this.currentPid = data.msg;
                    } else {
                        clearTimeout(restartTimer);
                        status.restart = true;
                        status.refresh = null;
                        setTimeout(() => {
                            window.location = defaultPage + '/';
                        }, 5000);
                        return;
                    }
                }

                this.checkIsAlive = setTimeout(this.restartHandler, 250);
            },
            restartFailed() {
                status.restart = false;
            }
        }
    });
};
</script>
</%block>
<%block name="css">
<style>
.upgrade-notification {
    display: none;
}
</style>
</%block>
<%block name="content">
<%
try:
    themeSpinner = sbThemeName
except NameError:
    themeSpinner = app.THEME_NAME
%>
<h2>Performing Restart</h2>
<div class="messages">
    <div v-show="status.shutdown !== undefined">
        Waiting for Medusa to shut down:
        <img src="images/loading16-${themeSpinner}.gif" height="16" width="16" v-show="status.shutdown === null" />
        <img src="images/yes16.png" height="16" width="16" v-show="status.shutdown === true" />
    </div>
    <div v-show="status.restart !== undefined">
        Waiting for Medusa to start again:
        <img src="images/loading16-${themeSpinner}.gif" height="16" width="16" v-show="status.restart === null" />
        <img src="images/yes16.png" height="16" width="16" v-show="status.restart === true" />
        <img src="images/no16.png" height="16" width="16" v-show="status.restart === false" />
    </div>
    <div v-show="status.refresh !== undefined">
        Loading the default page:
        <img src="images/loading16-${themeSpinner}.gif" height="16" width="16" />
    </div>
    <div v-show="status.restart === false">
        Error: The restart has timed out, perhaps something prevented Medusa from starting again?
    </div>
</div>
</%block>

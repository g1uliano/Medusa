<%inherit file="/layouts/main.mako"/>
<%block name="scripts">
<script>
window.app = {};
const startVue = () => {
    window.app = new Vue({
        el: '#vue-wrap',
        metaInfo: {
            title: 'Config - Backup/Restore'
        },
        data() {
            return {
                header: 'Backup/Restore',
                backup: {
                    disabled: false,
                    status: '',
                    dir: ''
                },
                restore: {
                    disabled: false,
                    status: '',
                    file: ''
                }
            };
        },
        mounted() {
            /** $('#backupDir').fileBrowser({
                title: 'Select backup folder to save to',
                key: 'backupPath'
            });
            $('#backupFile').fileBrowser({
                title: 'Select backup files to restore',
                key: 'backupFile',
                includeFiles: 1
            }); 
            */

            $('#config-components').tabs();
        },
        methods: {
            runBackup() {
                const { backup } = this;
                const { dir } = backup;

                this.backup.disabled = true;
                this.backup.status = MEDUSA.config.loading;

                $.get('config/backuprestore/backup', {
                    backupDir: dir
                }).done(data => {
                    this.backup.status = data;
                    this.backup.disabled = false;
                });
            },
            runRestore() {
                const { restore } = this;
                const { file } = restore;

                this.restore.disabled = true;
                this.restore.status = MEDUSA.config.loading;

                $.get('config/backuprestore/restore', {
                    backupFile: file
                }).done(data => {
                    this.restore.status = data;
                    this.restore.disabled = false;
                });
            }
        }
    });
};
</script>
</%block>
<%block name="content">
<h1 class="header">{{header}}</h1>
<div id="config">
    <div id="config-content">
        <form name="configForm" method="post" action="config/backuprestore">
            <div id="config-components">
                <ul>
                    <li><app-link href="#backup">Backup</app-link></li>
                    <li><app-link href="#restore">Restore</app-link></li>
                </ul>
                <div id="backup" class="component-group clearfix">
                    <div class="component-group-desc">
                        <h3>Backup</h3>
                        <p><b>Backup your main database file and config.</b></p>
                    </div>
                    <fieldset class="component-group-list">
                        <div class="field-pair">
                            Select the folder you wish to save your backup file to:
                            <br><br>
                            <!-- <input v-model="backup.dir" type="text" name="backupDir" id="backupDir" class="form-control input-sm input350"/>-->
                            <file-browser name="backupDir" ref="backupDirBrowser" id="backupDir" title="Select Show Location" :initial-dir="backup.dir" @update:location="backup.dir = $event"/>
                            <input @click="runBackup" :disabled="backup.disabled" class="btn-medusa btn-inline" type="button" value="Backup" id="Backup" />
                            <br>
                        </div>
                        <div v-html="backup.status" class="Backup" id="Backup-result"></div>
                    </fieldset>
                </div><!-- /component-group1 //-->
                <div id="restore" class="component-group clearfix">
                    <div class="component-group-desc">
                        <h3>Restore</h3>
                        <p><b>Restore your main database file and config.</b></p>
                    </div>
                    <fieldset class="component-group-list">
                        <div class="field-pair">
                            Select the backup file you wish to restore:
                            <br><br>
                            <!-- <input v-model="restore.file" type="text" name="backupFile" id="backupFile" class="form-control input-sm input350"/> -->
                            <file-browser name="backupFile" ref="backupFileBrowser" id="backupFile" title="Select Show Location" :initial-dir="restore.file" @update:location="restore.file = $event"/>
                            <input @click="runRestore" :disabled="restore.disabled" class="btn-medusa btn-inline" type="button" value="Restore" id="Restore" />
                            <br>
                        </div>
                        <div v-html="restore.status" class="Restore" id="Restore-result"></div>
                    </fieldset>
                </div><!-- /component-group2 //-->
            </div><!-- /config-components -->
        </form>
    </div>
</div>
<div class="clearfix"></div>
</%block>

import hudson.model.*;
import jenkins.model.*;
import com.cloudbees.plugins.credentials.SystemCredentialsProvider;
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey;
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl;
import com.cloudbees.plugins.credentials.CredentialsScope;
import com.cloudbees.plugins.credentials.domains.Domain;

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    // Jenkins SSH and Maven artifacts deployment Credentials
    println "--> Registering Credentials"
    def system_credentials_provider = SystemCredentialsProvider.getInstance()

    def ssh_key_description = "Jenkins Master"

    ssh_credentials_exist = false
    system_credentials_provider.getCredentials().each {
        credentials = (com.cloudbees.plugins.credentials.Credentials) it
        if ( credentials.getDescription() == ssh_key_description) {
            ssh_credentials_exist = true
            println("Found existing credentials: " + ssh_key_description)
        }
    }

    if(!ssh_credentials_exist) {
        println("Adding credentials: " + ssh_key_description)
        def ssh_key_scope = CredentialsScope.GLOBAL
        def ssh_key_id = "jenkins-master"
        def ssh_key_username = "jenkins"
        def ssh_key_private_key_source = new BasicSSHUserPrivateKey.UsersPrivateKeySource()
        def ssh_key_passphrase = null

        def ssh_key_domain = Domain.global()
        def ssh_key_creds = new BasicSSHUserPrivateKey(ssh_key_scope,ssh_key_id,ssh_key_username,ssh_key_private_key_source,ssh_key_passphrase,ssh_key_description)

        system_credentials_provider.getStore().addCredentials(ssh_key_domain,ssh_key_creds)
    }

    // Save the state
    instance.save()
}

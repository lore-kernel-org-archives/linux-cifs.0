From: Ankit Jain <jankit-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Use systemd's mechanism for getting password,
 if present
Date: Tue, 26 Jun 2012 12:34:26 +0530
Message-ID: <4FE95EFA.4030809@suse.com>
References: <4FE43C1F.8060605@suse.com> <20120625152439.1a68fb6f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120625152439.1a68fb6f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/26/2012 12:54 AM, Jeff Layton wrote:
> On Fri, 22 Jun 2012 15:04:23 +0530
> Ankit Jain <jankit-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> If the mount requests are "from" cifstab, then just asking for
>> "Password:" would be unclear, this asks it as:
>>   "Password for user@.. :"
>>
>>   I'm not subscribed to the mailing list.
>>
>> ---
>> mount.cifs: Use systemd's mechanism for getting password, if present.
>>     
>> If systemd is running, then use /bin/systemd-ask-password to get
>> the password instead of get_pass(..) .
>>
>> Reference: bug: https://bugzilla.novell.com/show_bug.cgi?id=767894
>>
>> diff --git a/mount.cifs.c b/mount.cifs.c
>> index 6f3f382..d721de6 100644
>> --- a/mount.cifs.c
>> +++ b/mount.cifs.c
>> @@ -1687,6 +1687,58 @@ drop_child_privs(void)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * If systemd is present, then try to get password via
>> + * /bin/systemd-ask-password, else just use getpass(..)
>> + */
>> +static char*
>> +get_password(const char *prompt, char *input, int capacity)
>> +{
>> +	int is_systemd_running;
>> +	struct stat a, b;
>> +
>> +	/* We simply test whether the systemd cgroup hierarchy is
>> +	 * mounted */
>> +	is_systemd_running = (lstat("/sys/fs/cgroup", &a) == 0)
>> +		&& (lstat("/sys/fs/cgroup/systemd", &b) == 0)
>> +		&& (a.st_dev != b.st_dev);
>> +
>> +	if (is_systemd_running) {
>> +		/* systemd */
>> +		char *cmd;
>> +		FILE *fp = NULL;
>> +
>> +		if (asprintf(&cmd, "/bin/systemd-ask-password \"%s\"", prompt) >= 0) {
>> +			fp = popen (cmd, "re");
>> +			free (cmd);
>> +		}
>> +
>> +		if (!fp)
>> +			return NULL;
>> +
> 
> What if systemd is running but we can't call /bin/systemd-ask-password
> for some reason? Like, maybe it doesn't exist? Should this then fall
> back to trying to get the password the old-fashioned way?

My first draft of this patch, in fact, did a fallback to get_pass(..) in
case that binary wasn't present. But AFAIU, if systemd is present and we
just use get_pass(..), user won't get that prompt and can't really
interactively give the password. This is the current problem infact.
Also, /bin/systemd-ask-password seems to be part of the core systemd
package (on opensuse 12.1 atleast).

> 
> Hmmm...the manpage for this command also says:
> 
>        The purpose of this tool is to query system-wide passwords --
>        that is passwords not attached to a specific user account.
>        Examples include: unlocking encrypted hard disks when they are
>        plugged in or at boot, entering an SSL certificate passphrase
>        for web and VPN servers.
> 
> ...does this really match that use-case? Hypothetically...
> 
> Suppose a user mount is set up in /etc/fstab and then the user calls:
> 
>     $ mount /mnt/cifs
> 
> ...or something along those lines. It used to be that he'd get a
> password prompr on his terminal if one wasn't in the fstab. Will that
> still be the case here? Or will this "broadcast" some sort of password
> request all over the machine?

Yeah, mount.cifs will use /bin/systemd-ask-password, which would
basically cause all the systemd password agents to try and get the
password. One of those is asking for password on that terminal. And one
of the agents does a wall(1) for the request. It would depend on what
that distro installs, i guess.

So, one of the agents *will* indeed ask for password on the same
terminal, so that should mimic (almost) the older behavior. Incase we
don't have this fix, or systemd-ask-password is not present, then the
user will have to specify the password in cifstab or in mount options.

I have tested only on openSUSE 12.1 btw.

Thanks,
-Ankit
> 
>> +		if (fgets(input, capacity, fp)) {
>> +			int len = strlen(input);
>> +			if (input[len - 1] == '\n')
>> +				input[len - 1] = '\0';
>> +		}
>> +
>> +		fclose(fp);
>> +	} else {
>> +		/* getpass is obsolete, but there's apparently nothing that replaces it */
>> +		char *tmp_pass = getpass(prompt);
>> +		if (!tmp_pass)
>> +			return NULL;
>> +
>> +		strncpy(input, tmp_pass, capacity - 1);
>> +		input[capacity - 1] = '\0';
>> +
>> +		/* zero-out the static buffer */
>> +		memset(tmp_pass, 0, strlen(tmp_pass));
>> +	}
>> +
>> +	return input;
>> +}
>> +
>>  static int
>>  assemble_mountinfo(struct parsed_mount_info *parsed_info,
>>  		   const char *thisprogram, const char *mountpoint,
>> @@ -1768,14 +1820,20 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>>  	}
>>  
>>  	if (!parsed_info->got_password) {
>> -		/* getpass is obsolete, but there's apparently nothing that replaces it */
>> -		char *tmp_pass = getpass("Password: ");
>> -		if (!tmp_pass) {
>> +		char tmp_pass[MOUNT_PASSWD_SIZE + 1];
>> +		char *prompt = NULL;
>> +
>> +		if(asprintf(&prompt, "Password for %s@%s: ", parsed_info->username, orig_dev) < 0)
>> +			prompt = NULL;
>> +
>> +		if (get_password(prompt ? prompt : "Password: ", tmp_pass, MOUNT_PASSWD_SIZE + 1)) {
>> +			rc = set_password(parsed_info, tmp_pass);
>> +		} else {
>>  			fprintf(stderr, "Error reading password, exiting\n");
>>  			rc = EX_SYSERR;
>> -			goto assemble_exit;
>>  		}
>> -		rc = set_password(parsed_info, tmp_pass);
>> +
>> +		free(prompt);
>>  		if (rc)
>>  			goto assemble_exit;
>>  	}
>>
> 
> 


-- 
Ankit Jain
SUSE Labs

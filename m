From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 16:38:09 +0530
Message-ID: <4E942399.8050807@suse.de>
References: <4E940E2B.4050705@suse.de> <20111011063236.3fb399e0@tlielax.poochiereds.net>
Reply-To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011063236.3fb399e0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/11/2011 04:02 PM, Jeff Layton wrote:
> On Tue, 11 Oct 2011 15:06:43 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> Thus spake Jeff Layton:
>>
>> "Making that a module parm would allow you to set that parameter at boot
>> time without needing to add special startup scripts. IMO, all of the
>> procfile "switches" under /proc/fs/cifs should be module parms
>> instead."
>>
>> This seems reasonable so this patch makes OplockEnabled a module
>> parameter and rename it to enable_oplocks to comply with the coding
>> conventions. This patch removes the proc file handling pertaining to
>> /proc/fs/cifs/OplockEnabled which would no longer be required if this
>> patch gets accepted.
>>
>> This patch doesn't alter the default behavior (Oplocks enabled by
>> default). To disable oplocks when loading the module, use
>>  
>>    modprobe cifs enable_oplocks=0
>>
>> Note:
>> (a) I'm little worried about eliminating an already known interace to
>>     enable/disable Oplocks. An update to README file mentioning this info
>>     is planned. Do we need to warn users before pulling it off? Any
>>     suggestions on how we could do this?
>> (b) Most of the /proc/fs/cifs switches could be converted to a module
>>     param for e.g. LookupCacheEnabled, LinuxExtensionsEnabled,
>>     MultiuserMount etc. I'll post further patches once this gets
>>     accepted.
>>
> 
> Yeah, I don't think we ought to just rip out these interfaces
> unannounced. What should probably happen is this:
> 
> Add the new module parms, and a patch that makes a printk pop when the
> old interfaces are used. The printk should announce something like:
> 
> "The /proc/fs/cifs/foo interface will be removed in kernel version 3.x.
> Please migrate to using the 'enable_foo' module parameter in cifs.ko."
> 
> Make the 3.x version be 2 releases out. Then have patches ready to go
> to remove those interfaces when the 3.x merge window opens.

Makes sense. Thanks.

>> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  fs/cifs/cifs_debug.c |   40 ----------------------------------------
>>  fs/cifs/cifsfs.c     |    4 +++-
>>  fs/cifs/cifsglob.h   |    4 +++-
>>  fs/cifs/dir.c        |    2 +-
>>  fs/cifs/file.c       |    4 ++--
>>  5 files changed, 9 insertions(+), 45 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 2fe3cf1..393b37b 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -418,7 +418,6 @@ static const struct file_operations cifs_stats_proc_fops = {
>>  
>>  static struct proc_dir_entry *proc_fs_cifs;
>>  static const struct file_operations cifsFYI_proc_fops;
>> -static const struct file_operations cifs_oplock_proc_fops;
>>  static const struct file_operations cifs_lookup_cache_proc_fops;
>>  static const struct file_operations traceSMB_proc_fops;
>>  static const struct file_operations cifs_multiuser_mount_proc_fops;
>> @@ -439,7 +438,6 @@ cifs_proc_init(void)
>>  #endif /* STATS */
>>  	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
>>  	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
>> -	proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_oplock_proc_fops);
>>  	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
>>  		    &cifs_linux_ext_proc_fops);
>>  	proc_create("MultiuserMount", 0, proc_fs_cifs,
>> @@ -463,7 +461,6 @@ cifs_proc_clean(void)
>>  	remove_proc_entry("Stats", proc_fs_cifs);
>>  #endif
>>  	remove_proc_entry("MultiuserMount", proc_fs_cifs);
>> -	remove_proc_entry("OplockEnabled", proc_fs_cifs);
>>  	remove_proc_entry("SecurityFlags", proc_fs_cifs);
>>  	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
>>  	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
>> @@ -509,43 +506,6 @@ static const struct file_operations cifsFYI_proc_fops = {
>>  	.write		= cifsFYI_proc_write,
>>  };
>>  
>> -static int cifs_oplock_proc_show(struct seq_file *m, void *v)
>> -{
>> -	seq_printf(m, "%d\n", oplockEnabled);
>> -	return 0;
>> -}
>> -
>> -static int cifs_oplock_proc_open(struct inode *inode, struct file *file)
>> -{
>> -	return single_open(file, cifs_oplock_proc_show, NULL);
>> -}
>> -
>> -static ssize_t cifs_oplock_proc_write(struct file *file,
>> -		const char __user *buffer, size_t count, loff_t *ppos)
>> -{
>> -	char c;
>> -	int rc;
>> -
>> -	rc = get_user(c, buffer);
>> -	if (rc)
>> -		return rc;
>> -	if (c == '0' || c == 'n' || c == 'N')
>> -		oplockEnabled = 0;
>> -	else if (c == '1' || c == 'y' || c == 'Y')
>> -		oplockEnabled = 1;
>> -
>> -	return count;
>> -}
>> -
>> -static const struct file_operations cifs_oplock_proc_fops = {
>> -	.owner		= THIS_MODULE,
>> -	.open		= cifs_oplock_proc_open,
>> -	.read		= seq_read,
>> -	.llseek		= seq_lseek,
>> -	.release	= single_release,
>> -	.write		= cifs_oplock_proc_write,
>> -};
>> -
>>  static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
>>  {
>>  	seq_printf(m, "%d\n", linuxExtEnabled);
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 3e29899..37c2fbb 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -52,7 +52,6 @@
>>  int cifsFYI = 0;
>>  int cifsERROR = 1;
>>  int traceSMB = 0;
>> -unsigned int oplockEnabled = 1;
>>  unsigned int linuxExtEnabled = 1;
>>  unsigned int lookupCacheEnabled = 1;
>>  unsigned int multiuser_mount = 0;
>> @@ -81,6 +80,9 @@ module_param(echo_retries, ushort, 0644);
>>  MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
>>  			       "reconnecting server. Default: 5. 0 means "
>>  			       "never reconnect.");
>> +unsigned int enable_oplocks = 1;
>> +module_param(enable_oplocks, bool, 0644);
>> +MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default: 1.");
> 
> I think you want this as "Default: true" since this is a bool?
> 

No. From the definition of module_param:

(snip)
 * Standard types are:
 *      byte, short, ushort, int, uint, long, ulong
 *      charp: a character pointer
 *      bool: a bool, values 0/1, y/n, Y/N.
 */
#define module_param(name, type, perm)                          \
        module_param_named(name, name, type, perm)

I should perhaps add y/Y.

I'll repost the patch.


Thanks
Suresh

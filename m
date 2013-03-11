From: Arthur Marsh <arthur.marsh-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: Re: fs: Limit sys_mount to only request filesystem modules prevents
 mount -t cifs from working
Date: Tue, 12 Mar 2013 02:31:14 +1030
Message-ID: <513DFFCA.6010304@internode.on.net>
References: <513DD49F.8010301@internode.on.net> <87obeqnjlm.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87obeqnjlm.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



Eric W. Biederman wrote, on 12/03/13 00:07:
> Arthur Marsh<arthur.marsh-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>  writes:
>
>> Hi, I found that Linux kernel 3.9.0-rc2 would not mount a remote cifs
>> filesystem, and ran a git bisect which identified the following
>> commit:
>>
>> Is there a patch already present somewhere to fix this problem?
>>
>
> Grr.  It was in linux-next for nearly a week and I checked an double
> checked that patch.
>
> This should fix it.
>
> Eric
>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1a052c0..3cf8a15 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -777,6 +777,7 @@ struct file_system_type cifs_fs_type = {
>   	.kill_sb = cifs_kill_sb,
>   	/*  .fs_flags */
>   };
> +MODULE_ALIAS_FS("cifs");
>   const struct inode_operations cifs_dir_inode_ops = {
>   	.create = cifs_create,
>   	.atomic_open = cifs_atomic_open,
>

Confirmed... cifs mounts now work again thanks.

Regards,

Arthur.

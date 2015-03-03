From: "pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How does mounting with BACKUP INTENT work in CIFS?
Date: Tue, 3 Mar 2015 15:20:34 -0500
Message-ID: <CAPpy_fGR9Y9vm2pp5e8287tkHpiazHoMaqAS044Fqa=NGmL7zQ@mail.gmail.com>
References: <CAPpy_fGs693BzGS3-pjtKvvkFo+Lwgqjgwq+4WmUthcUMRM0uA@mail.gmail.com>
	<CACyXjPwOaZ9VNeXwyh0t8PYOR2gTNWiUJLm_ecgCQPU-PbVToA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPwOaZ9VNeXwyh0t8PYOR2gTNWiUJLm_ecgCQPU-PbVToA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 3, 2015 at 2:59 PM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Mar 3, 2015 at 11:52 AM, pisymbol . <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> A colleague and I just witnessed that we could not write an access
>> time of a file on a CIFS mount using CentOS 6.5 despite the fact we
>> mounted it with "Backup Intent."
>>
>> My current theory is that via CIFS, the DACL checks still apply
>> because Window backup clients use a different API to access files.
>> However, I'm not 100% sure.
>
> BackupIntent is only useful if you also have SeBackupPrivilege or
> SeRestorePrivilege or both. That is why it worked when you added
> BackupOperators, because privileges are associated with groups.

So the domain user in Windows has to have these privileges set AND be
part of the Backup Operators group for all of this to work?

-aps

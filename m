From: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Thu, 31 Aug 2017 23:36:01 +0200
Message-ID: <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504213298-27431-1-git-send-email-linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Content-Language: en-MW
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Lo! To give a bit more background to this (the mail I reply to was the
first I sent with git send-email and I missed some details): Maybe I'm
over stretching my abilities/position as regression tracker with this
RFC for a revert, but I hope it at least triggers a discussion if such a
revert should be done or not.

The problem described in below patch description is known for a few
weeks already, but the bugzilla entry about it got ignored by the CIFS
developers; the same happened to a mail one affected user sent to
cifs-devel.

I should have send this revert RFC earlier, because I think more users
will be confused by the switch to SMB3, because the error messages they
get when trying to mount a SMB1/CIFS only share are not very helpful. I
myself had one system which regressed and made me look closer. And I
heard at least some widespread NAS boxes only support CIFS/SMB1 by
default :-/

Note: I only light-tested this revert and it worked fine for me (I still
could mount a CIFS/SMB1 only samba share and was still able to mount a
samba share on a different host with SMB3). But I'm not familiar with
the code I modify here. Hence someone who is (Steven?) IMHO should ACK
this before it gets applied.

Ciao, Thorsten


On 31.08.2017 23:01, Thorsten Leemhuis wrote:
> This reverts commit eef914a9eb5eb83e60eb498315a491cd1edc13a1 (
> [SMB3] Improve security, move default dialect to SMB3 from old CIFS), 
> as it confuses users: https://bugzilla.kernel.org/show_bug.cgi?id=196599
> 
> It was a patch to improve security by switching to SMB3 by default and
> support SMB1 (aka CIFS) only when explicitly requested, as the latter
> is not considered secure anymore (see below for details). This is one of
> the rare cases where regressions are unavoidable and accepted in Linux.
> But that's bad enough already, so we at least should make it easy for
> people to get an idea why something suddenly stopped working with a
> newer kernel version. That's not the case, because due to eef914a9eb5e
> a mount of a server that only supports CIFS/SMB1 with mount.cifs fails
> with a misleading message:
> 
>> mount error(112): Host is down > Refer to the mount.cifs(8) manual
>> page (e.g. man mount.cifs)
> 
> The corresponding message in the kernel log is just as unhelpful:
> 
>> CIFS VFS: cifs_mount failed w/return code = -112
> 
> This needs to be improved. Hence remove this for now, as the world won't
> end suddenly if this gets delayed one or two cycles and resubmitted in
> a way that leads to a more helpful error message.
> 
> For completeness, here are parts from the original patch description:
> 
>> Due to recent publicity about security vulnerabilities in the much
>> older CIFS dialect, move the default dialect to the widely accepted
>> (and quite secure) SMB3.0 dialect from the old default of the CIFS
>> dialect.
>>
>> We do not want to be encouraging use of less secure dialects, and
>> both Microsoft and CERT now strongly recommend not using the older
>> CIFS dialect (SMB Security Best Practices "recommends disabling
>> SMBv1").
>>
>> SMB3 is both secure and widely available: in Windows 8 and later,
>> Samba and Macs.
>>
>> Users can still choose to explicitly mount with the less secure
>> dialect (for old servers) by choosing "vers=1.0" on the cifs mount
> 
> Signed-off-by: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
> CC: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/connect.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 59647eb..6ab261cd 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1272,9 +1272,9 @@ static int cifs_parse_security_flavors(char *value,
>  
>  	vol->actimeo = CIFS_DEF_ACTIMEO;
>  
> -	/* FIXME: add autonegotiation for SMB3 or later rather than just SMB3 */
> -	vol->ops = &smb30_operations; /* both secure and accepted widely */
> -	vol->vals = &smb30_values;
> +	/* FIXME: add autonegotiation -- for now, SMB1 is default */
> +	vol->ops = &smb1_operations;
> +	vol->vals = &smb1_values;
>  
>  	vol->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
>  
> 

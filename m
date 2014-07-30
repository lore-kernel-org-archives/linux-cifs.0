From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 10/16] CIFS: Use multicredits for SMB 2.1/3 writes
Date: Tue, 29 Jul 2014 21:06:14 -0500
Message-ID: <CADT32eKD1RBL-53Ap44wC3Fi8mCVwxsyoOgZvc0ED=FYA09SOQ@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-11-git-send-email-pshilovsky@samba.org>
	<CADT32e+E5C6gh2+qAt6K6D3NEOx7fZFrWn2sN4Ovs5evQjuW5w@mail.gmail.com>
	<CAKywueQa8toYf=-XAu_tM12ZSkUiSnc4Pke_sDMpbBP5mXkMEg@mail.gmail.com>
	<CAKywueRfzhBFV7MV1SCLW6R+coxbmJFPNjc9inki+WXYkM-81g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRfzhBFV7MV1SCLW6R+coxbmJFPNjc9inki+WXYkM-81g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel, that would be fine


On Tue, Jul 29, 2014 at 2:56 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 2014-07-28 11:36 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> 2014-07-25 5:06 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> Looks correct.
>>>
>>> Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
>>
>> Thank you for reviewing the series!
>>
>>> Only  comment would be, wish there was a mnemonic/define for
>>> a regular op  when calling add_credits_and_wake_if() for optype
>>> such as CIFS_ECHO_OP or CIFS_OPBREAK_OP instead of 0.
>>
>> Yes, it can make sense but should be in another patch/series.
>>
>>> Oh and super nitpick...  s/reseted/reset/.
>>
>> Ok, will fix it in my smb2-dev branch on git.altlinux.org.
>>
>> --
>> Best regards,
>> Pavel Shilovsky.
>
> Shirish,
>
> I am going to add a check (as well as removing an unnecessary comment)
> to write part:
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 081529f..0dbd1de 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -230,6 +230,9 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon,
> struct smb_vol *volume_info)
>         wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
>         wsize = min_t(unsigned int, wsize, server->max_write);
>
> +       if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
> +               wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
> +
>         return wsize;
>  }
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3acef4b..5a6842c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -108,7 +108,6 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16
> smb2_cmd /* command */ ,
>         if (!tcon)
>                 goto out;
>
> -       /* BB FIXME when we do write > 64K add +1 for every 64K in req or rsp */
>         /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
>         /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
>         if ((tcon->ses) &&
>
> and the same check to read part:
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0dbd1de..d0210a8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -246,6 +246,9 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon,
> struct smb_vol *volume_info)
>         rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
>         rsize = min_t(unsigned int, rsize, server->max_read);
>
> +       if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
> +               rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
> +
>         return rsize;
>  }
>
> If you are ok with the changes I will update 10/16 and 16/16 patches
> and leave your Reviewed-by tags in my git tree. Thoughts?
>
> --
> Best regards,
> Pavel Shilovsky.

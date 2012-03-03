From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 14/17] CIFS: Convert lock type to 32 bit variable
Date: Sat, 3 Mar 2012 13:51:25 +0400
Message-ID: <CAKywueSz6qh2qC-4vBW5rHU+rN9Zx7_bwA4BcKhuzZokNnvu7A@mail.gmail.com>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
	<1330767438-19469-15-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-15-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/3/3 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> to handle SMB2 lock type field further.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A03 +--
> =A0fs/cifs/file.c =A0 =A0 | =A0 13 +++++++------
> =A02 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index e5179d4..0097973 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -552,8 +552,7 @@ struct cifsLockInfo {
> =A0 =A0 =A0 =A0__u64 offset;
> =A0 =A0 =A0 =A0__u64 length;
> =A0 =A0 =A0 =A0__u32 pid;
> - =A0 =A0 =A0 __u8 type;
> - =A0 =A0 =A0 __u16 netfid;
> + =A0 =A0 =A0 __u32 type;

resent as v2 according to the changes in patch #12.

--=20
Best regards,
Pavel Shilovsky.

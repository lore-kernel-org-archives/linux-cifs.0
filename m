From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v2 PATCH] CIFS: Fix incorrect max RFC1002 write size value
Date: Tue, 11 Oct 2011 14:55:33 +0400
Message-ID: <CAKywueSn7GwMc7=v9XzAQd6W401m=tEf=-RT6dq76W+NjhYGYA@mail.gmail.com>
References: <1318015651-18764-1-git-send-email-piastry@etersoft.ru>
	<20111009074549.711f1d31@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111009074549.711f1d31-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/9 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, =A07 Oct 2011 23:27:31 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> ..the length field has only 17 bits.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A04 ++--
>> =A01 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 633c246..1a645ee 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2807,10 +2807,10 @@ void cifs_setup_cifs_sb(struct smb_vol *pvol=
ume_info,
>>
>> =A0/*
>> =A0 * When the server doesn't allow large posix writes, only allow a=
 wsize of
>> - * 128k minus the size of the WRITE_AND_X header. That allows for a=
 write up
>> + * 2^17-1 minus the size of the WRITE_AND_X header. That allows for=
 a write up
>> =A0 * to the maximum size described by RFC1002.
>> =A0 */
>> -#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
>> +#define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4=
)
>>
>> =A0/*
>> =A0 * The default wsize is 1M. find_get_pages seems to return a maxi=
mum of 256
>
> Looks fine...
>
> If we're going to do this though, should we also consider getting rid
> of the bogus pad in the WRITE_REQ header? It's preferable to make the
> wsize as large as we can get away with...
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Steve, is there any chance to get it into 3.1?

--=20
Best regards,
Pavel Shilovsky.

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
Date: Tue, 12 Jul 2011 09:50:51 +0400
Message-ID: <CAKywueQ8uAVMD3YtW0b9sgA7wyGanJcYg0e7bYApLzV7EMgX_g@mail.gmail.com>
References: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
	<20110711102126.5174bc51@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110711102126.5174bc51-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 11 Jul 2011 10:16:34 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> ...as that function can sleep.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index ceab134..dd695c5 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void =
*data)
>>
>> =A0 =A0 =A0 rc =3D compare_mount_options(sb, mnt_data);
>> =A0out:
>> - =A0 =A0 cifs_put_tlink(tlink);
>> =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> + =A0 =A0 cifs_put_tlink(tlink);
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>
> Steve, this should probably be pushed to 3.0 if possible. This can
> deadlock if you end up putting the last tcon reference in this call.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

This looks good to me. Thanks!

--=20
Best regards,
Pavel Shilovsky.

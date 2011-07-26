From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v4 PATCH 0/5] Simplify demultiplex thread
Date: Tue, 26 Jul 2011 23:32:56 +0400
Message-ID: <CAKywueQGGhsZ1djCO3SESHP-_A_jAF9RqqAueW8AxL1R35LK3w@mail.gmail.com>
References: <1311519630-2500-1-git-send-email-piastryyy@gmail.com>
	<20110726081400.6a7ed834@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110726081400.6a7ed834-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sun, 24 Jul 2011 19:00:30 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This patchset is going to make demultiplex code smaller and let us i=
ntergrate SMB2 protocol support easier further.
>>
>> I successfully tested it with Connectathon Testsuites and two parall=
el mount/umount scripts.
>>
>> This is the 4rd version of the patchset that includes minor changes =
for patch #1.
>>
>>
>> Pavel Shilovsky (5):
>> =A0 CIFS: Move buffer allocation to a separate function
>> =A0 CIFS: Simplify socket reading in demultiplex thread
>> =A0 CIFS: Move RFC1002 check to a separate function
>> =A0 CIFS: Move mid search to a separate function
>> =A0 CIFS: Cleanup demupltiplex thread exiting code
>>
>> =A0fs/cifs/connect.c | =A0653 ++++++++++++++++++++++++++++----------=
---------------
>> =A01 files changed, 346 insertions(+), 307 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> This patchset seems like a good start. It does have some warts...
>
> =A0static int
> +read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_=
msg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kvec *iov, unsigned int to_re=
ad,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int *ptotal_read, bool is_h=
eader_read)
>
>
> ...that is_header_read parm could probably be done away with by movin=
g
> the special handling into the caller. Making these routines more
> general purpose would be preferable.

I agree - it is a good thing for further work with demultiplex thread.

>
> That said, it's still a good starting point for future cleanup, so I'=
m
> inclined to ACK the set. I also ran it through some basic smoke testi=
ng
> and didn't see any problems.
>
> Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Thank you for testing this! Note, that this patchset is also a
starting point for SMB2 support integration and merging this now makes
this process easier.

--=20
Best regards,
Pavel Shilovsky.

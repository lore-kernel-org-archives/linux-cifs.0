From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix DFS handling in cifs_get_file_info
Date: Sat, 22 Oct 2011 14:07:56 -0500
Message-ID: <CAH2r5msGPAovnV6F0FYMf=ydWUrsd2pY4nXHwm=L3tDzmaL8Uw@mail.gmail.com>
References: <1319279870-17657-1-git-send-email-piastry@etersoft.ru>
	<20111022070656.4eb6129c@tlielax.poochiereds.net>
	<CAKywueQuSgAAsO2YN95m7E6jDVVw21v66S+-2bdMxKXm2=Xn+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQuSgAAsO2YN95m7E6jDVVw21v66S+-2bdMxKXm2=Xn+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Sat, Oct 22, 2011 at 6:12 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> 2011/10/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> I think this looks fine. Did you actually see a problem with this or
>> did you notice it by inspection?
>
> I caught it while working with SMB2 code - so, I didn't faced with an=
y
> real problem connected with it.
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve

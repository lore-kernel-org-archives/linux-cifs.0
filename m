From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix DFS handling in cifs_get_file_info
Date: Sat, 22 Oct 2011 15:12:38 +0400
Message-ID: <CAKywueQuSgAAsO2YN95m7E6jDVVw21v66S+-2bdMxKXm2=Xn+Q@mail.gmail.com>
References: <1319279870-17657-1-git-send-email-piastry@etersoft.ru>
	<20111022070656.4eb6129c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111022070656.4eb6129c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> I think this looks fine. Did you actually see a problem with this or
> did you notice it by inspection?

I caught it while working with SMB2 code - so, I didn't faced with any
real problem connected with it.

-- 
Best regards,
Pavel Shilovsky.

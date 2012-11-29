From: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
Subject: Re: [RFQ PATCH] cifs: Change default security error message
Date: Thu, 29 Nov 2012 19:47:10 +0100
Message-ID: <20121129184709.GR27196@axis.com>
References: <20121129173053.GQ27196@axis.com>
 <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:52:03AM -0600, Steve French wrote:
> This has already been changed in the cifs-2.6.git for-next  branch.
> We had run into problems with Apple Server with ntlmv2 so it took
> longer than expected to test it, and it was too late for 3.7 so the
> patch to move to ntlmssp encapsulated ntlmv2 which removes this
> warning is in cifs-2.6.git and queued for 3.8

Oh excellent. What=B4s the git url for the cifs-tree?
The one referred to in MAINTAINERS doesn=B4t seem to work.

T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.g=
it

Or possibly I=B4m missing something. :-)

Thanks,

/^JN - Jesper Nilsson
--=20
               Jesper Nilsson -- jesper.nilsson-VrBV9hrLPhE@public.gmane.org

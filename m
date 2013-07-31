From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifs: extend the buffer length enought for sprintf() using
Date: Wed, 31 Jul 2013 11:55:08 -0400
Message-ID: <CAFB9KM1buPJYpF6PdqVWYLFEuURhf07iDBaQzN3aWyRPWdGGTw@mail.gmail.com>
References: <51E5E9DA.8020603@asianux.com>
	<CAFB9KM2nJEt-O+o=4bkxNMJ2Fr0TfjkpRF=7B98=Lp9zFu8_og@mail.gmail.com>
	<CAH2r5msQEbQWpE+wqEoLY_++=ywDVoAg_vmWB3kJG8=ECHC3Pg@mail.gmail.com>
	<CAFB9KM0rEDyE6hb8t-gDLTDKq9kaRr4Bhs7SLBEZTnyH5u5U-A@mail.gmail.com>
	<51E74008.8050308@asianux.com>
	<CAFB9KM2MbLuETpoN9wafZLq6B9StjtXnG15G16uGcOcnRM8+sA@mail.gmail.com>
	<51E88FF0.2010101@asianux.com>
	<20130719064531.2a9836f5@tlielax.poochiereds.net>
	<CAH2r5mvccBQRikYbbUppmbCO1naSOOMJ+wVWxQEQBxhDdmnP_w@mail.gmail.com>
	<51EC890D.7010306@asianux.com>
	<CAH2r5mvPC0jiSDh5qTgerEV3JnRwcPPkKvnbT1QCO0CGiVngjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvPC0jiSDh5qTgerEV3JnRwcPPkKvnbT1QCO0CGiVngjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 31, 2013 at 12:59 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I updated the version of the patch slightly which is in cifs-2.6.git
> so we don't have to rename the MAX_DOMAINNAME_SIZE field multiple
> times.  Let me know if you see problems.  It could make Scott's
> followup patch a little easier to understand without the renamed
> #define.
> --
> Thanks,
>
> Steve

+1.  I agree it streamlines the other patch set.

-- 
Peace and Blessings,
-Scott.

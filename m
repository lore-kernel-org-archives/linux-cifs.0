From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cthon failure
Date: Tue, 26 Aug 2014 09:12:46 -0700
Message-ID: <20140826161246.GB5602@samba2>
References: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q@mail.gmail.com>
 <20140821211338.GC17035@samba2>
 <CAH2r5ms5=vV2XD2oP2NoaLavsZCo=x4w=w7vvshzNQRNJ1RkFw@mail.gmail.com>
 <20140826001033.GA7407@samba2>
 <CAH2r5mtdkx=iPmQBUq2RLf15zRfLnfFxZU6Y7bRLRtU09Cv1mw@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtdkx=iPmQBUq2RLf15zRfLnfFxZU6Y7bRLRtU09Cv1mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 25, 2014 at 09:04:21PM -0500, Steve French wrote:
> I can create a bug but the problem is pretty straightforward

Why can't I reproduce it ?

> [2014/08/25 14:12:33.849169,  1]
> ../source3/smbd/file_access.c:191(can_set_delete_on_close)
>   can_set_delete_on_close: file newfile1 delete on close flag set but
> file attribute is readonly.

Who is setting the file attribute readonly ? Show
me the entire trace please. Or alternatively, you
could JUST GIVE ME WHAT I ASKED FOR !!!!!

(I'm getting frustrated Steve, because your
refusal to give me the data I'm asking for
is delaying me fixing this - if it's a server
bug).

Is the client code doing it ? If so, then the bug is
in the client - *don't do that*. When talking on a
connection with UNIX extensions why are *any* DOS
attributes getting set ?

Jeremy.

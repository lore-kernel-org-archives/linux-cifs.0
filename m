From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Patch numeric domain names
Date: Fri, 4 Nov 2011 11:20:16 -0500
Message-ID: <CAH2r5mv8_uY47UngF=OXU4xm--ti1WXjQtNx8mgA6NOLVSraCg@mail.gmail.com>
References: <005801cc9a9e$59d4f2a0$0d7ed7e0$@gmail.com>
	<20111104095253.14e7f0a5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Donald R. Gray Jr" <donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111104095253.14e7f0a5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 4, 2011 at 8:52 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 3 Nov 2011 23:03:36 -0400
> "Donald R. Gray Jr" <donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Patch to allow numbers in domain names for cifscreds.
>
> According to this msdn page, we should actually be able to allow more
> characters than just alphanumerics in NetBIOS domain names:
>
> =A0 =A0http://support.microsoft.com/kb/909264
>
> Would it be better to fix the code to just follow those rules instead=
?

Yes - there are only about 10 restricted characters, and even those
might not be restricted to some non-Windows servers.  It is
reasonable to warn in userspace on some of those, but
risky to forbid certain domain names.


--=20
Thanks,

Steve

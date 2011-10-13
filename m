From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Should multiuser imply "noperm" mount option?
Date: Thu, 13 Oct 2011 13:33:59 -0500
Message-ID: <CAH2r5msBBUPAAKenRf-944cZDha8AkQMN-MR28x_SSwyJYY5qA@mail.gmail.com>
References: <CAH2r5mvEq3nrx=Qu0gkn9Oaa-WYK-EuJqqNKYLQOY4QmsrgHXA@mail.gmail.com>
	<20111013143409.7b4ec34a@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111013143409.7b4ec34a-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

aaah - great, missed that.

Wish it were easier to setup kerberos (and that we had Samba 4 DC out)
so we could turn multiuser on by default ... (or if we could fix it
for ntlmv2)

On Thu, Oct 13, 2011 at 1:34 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 13 Oct 2011 13:12:20 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> If multiuser mount is enabled and we are getting and sending the
>> "correct" credentials - should we enable noperm by default (so we
>> don't do client side permission checking unless we are mounted as
>> single user - no multiuser)
>>
>
> It already does that. From the multiuser section of the
> mount.cifs manpage:
>
> =A0 =A0 =A0 =A0 =A0"With this change, it's feasible for the server to=
 handle
> =A0 =A0 =A0 =A0 =A0 permissions enforcement, so this option also impl=
ies "noperm"."
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Thanks,

Steve

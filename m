From: "Parzer, Peter" <Peter.Parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
Subject: AW: setfacl fix
Date: Mon, 18 Nov 2013 08:05:42 +0000
Message-ID: <CD0910ABB15D264A8E7AB76074385B0F6C85A9B9@EXC11.ads.krz.uni-heidelberg.de>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
	<1384614925.3216.6.camel@hh16.hh3.site>,<CAH2r5mvHzVXs4zuWZvL8ppBzaXSQHOykwu2Gdky3=ZQ9ZbPZcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvHzVXs4zuWZvL8ppBzaXSQHOykwu2Gdky3=ZQ9ZbPZcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: de-DE
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I can show you this bug. A share mounted from a Samba server 3.6.3 (Ubu=
ntu 12.04 Server) on Ubuntu 12.04 with kernel 3.2, cifs 1.76.

$ getfacl test
# file: test
# owner: parzerpeter
# group: dom=E4nen-benutzer
user::rwx
group::---
group:kjp-admins:rwx
mask::rwx
other::---
default:user::rwx
default:group::---
default:group:kjp-admins:rwx
default:mask::rwx
default:other::---

$ setfacl -m u:kjptest:rx test

$ getfacl test
# file: test
# owner: parzerpeter
# group: dom=E4nen-benutzer
user::rwx
user:kjptest:r-x
group::---
group:kjp-admins:rwx
mask::rwx
other::---

$ setfacl -m d:g:kjp-admins:rwx test

$ getfacl test
# file: test
# owner: parzerpeter
# group: dom=E4nen-benutzer
user::rwx
group::---
other::---
default:user::rwx
default:group::---
default:group:kjp-admins:rwx
default:mask::rwx
default:other::---


When changing the ACLs, the defaults are removed, and when changing the=
 defaults the ACLs are removed.

Peter
________________________________________
Von: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=
]&quot; im Auftrag von &quot;Steve French [smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Gesendet: Samstag, 16. November 2013 22:55
An: steve
Cc: Christoph Hellwig; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical
Betreff: Re: setfacl fix

On Sat, Nov 16, 2013 at 9:15 AM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>
>> > From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Date: Fri, 15 Nov 2013 20:41:32 -0600
>> > Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting P=
OSIX ACLs to
>> >  Samba
>> >
>> > setfacl over cifs mounts can remove the default ACL
>
> Hi
> cifs-utils 6.1 Samba 4.1.0
>
> I don't understand the '...over cifs mounts...' bit.
>
> Does it mean that if I have a share mounted on my Linux box and do a
> setfacl on a file in the share then the default acl will be removed?
>
> Sorry for a non dev question.

I was surprised too.  Over a cifs mount (to Samba, as Windows does not
support the POSIX style ACLs) it looks like many users paid attention
to only half the POSIX ACL, adding additional users or groups to the
(non-default) ACL and ignoring the default ACL or vice versa.  A user
reported the problem (with part of the ACL getting removed on setfacl
over a cifs mount) a couple days ago, and I found one older reference
to a similar problem.

--
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

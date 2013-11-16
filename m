From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setfacl fix
Date: Sat, 16 Nov 2013 15:55:07 -0600
Message-ID: <CAH2r5mvHzVXs4zuWZvL8ppBzaXSQHOykwu2Gdky3=ZQ9ZbPZcg@mail.gmail.com>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
	<1384614925.3216.6.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384614925.3216.6.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Nov 16, 2013 at 9:15 AM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>
>> > From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Date: Fri, 15 Nov 2013 20:41:32 -0600
>> > Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting POSIX ACLs to
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

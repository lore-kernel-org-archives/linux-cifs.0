From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible to make nfs aware of a inotify watch has been set.
Date: Thu, 29 Nov 2012 17:39:27 +0100
Message-ID: <CANXojcys4wR8N-R3oSjWRWJLsObn0Qf+i41vBUaNnJctdcrKVw@mail.gmail.com>
References: <CANXojcy9thLBwrENTkOTSSE17L3N17A8XsTmyNqq3oNdhW_Q_w@mail.gmail.com>
	<4FA345DA4F4AE44899BD2B03EEEC2FA90B329CFD@SACEXCMBX04-PRD.hq.netapp.com>
	<CANXojcxR9673fRObMLPSScogAN05RSVhPFoni=ENc6YDWq9T7w@mail.gmail.com>
	<1354202525.4064.1.camel@pico.ipa.ssimo.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA90B32AEB7@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA90B32AEB7-VGJ86jkg8PeBTCzCEi1xmXOR4cbS7gtM96Bgd4bDwmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/29 Myklebust, Trond <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>:
> On Thu, 2012-11-29 at 10:22 -0500, simo wrote:
>> On Thu, 2012-11-29 at 15:49 +0100, Stef Bon wrote:
>> > 2012/11/29 Myklebust, Trond <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>:
>> > >> -----Original Message-----
>> > >>
> NFSv4.1 actually has directory notifications which duplicate most of the
> functionality of dnotify. The question I'm asking is "Why should we do
> it?", not "can we do it?".
>
> Answers like "well Windows and iOS do it" aren't helpful unless they
> include a description of what Windows and iOS apps use it for that we
> can't already do on Linux.
> If the only application is beagle, then Linux has this really helpful
> utility called "ssh", which allows you to avoid wasting a load of
> network bandwidth...

No, sure, you should not do anything because others do it. But on the
other hand, if others do it, why don't you? Better copy a good idea
than be stubborn for ever.

And yes there is no such thing as a killer app, but in my opinion it's
the user experience. It's so much better when your system keeps track
on shared network resources.

But first things first,I will try to make the first option work, which
was the use of a remote notifyfs server. This works of course only
with linux like systems: so not when the remote server is a Windows
server.

I know that SMB (2?) has the ability to send a SMB2_CHANGE_NOTIFY
request. Steve French and I had earlier a conversation about that.

Before trying to make this work with cifs I've tried to make this work
using a FUSE fs with libsmbclient. I did not get it working since the
adding of an fd to the FUSE fs's eventloop was not easy, and required
a rewrite of libsmbclient.
The writing of the FUSE fs was easy, since there are already some examples.

Stef

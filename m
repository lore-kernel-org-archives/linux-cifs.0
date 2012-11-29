From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Possible to make nfs aware of a inotify watch has been set.
Date: Thu, 29 Nov 2012 17:26:38 -0500
Message-ID: <1354227998.4064.11.camel@pico.ipa.ssimo.org>
References: <CANXojcy9thLBwrENTkOTSSE17L3N17A8XsTmyNqq3oNdhW_Q_w@mail.gmail.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90B329CFD@SACEXCMBX04-PRD.hq.netapp.com>
	 <CANXojcxR9673fRObMLPSScogAN05RSVhPFoni=ENc6YDWq9T7w@mail.gmail.com>
	 <1354202525.4064.1.camel@pico.ipa.ssimo.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90B32AEB7@SACEXCMBX04-PRD.hq.netapp.com>
	 <CANXojcys4wR8N-R3oSjWRWJLsObn0Qf+i41vBUaNnJctdcrKVw@mail.gmail.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90B32B2A0@SACEXCMBX04-PRD.hq.netapp.com>
	 <1354219557.4064.7.camel@pico.ipa.ssimo.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90B32D9D4@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA90B32D9D4-VGJ86jkg8PeBTCzCEi1xmXOR4cbS7gtM96Bgd4bDwmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-11-29 at 21:09 +0000, Myklebust, Trond wrote:
> On Thu, 2012-11-29 at 15:05 -0500, simo wrote:
> > On Thu, 2012-11-29 at 17:11 +0000, Myklebust, Trond wrote:
> > > The idea that "if we build a bridge, they will come to us" is what
> > > gave
> > > rise to dnotify, then inotify (nobody came, so let's build a bigger
> > > bridge) and fsnotify (make it a toll bridge). Nobody is using those
> > > interfaces much on local filesystems, so why is adding it to NFS and
> > > CIFS going to be such a game changer?
> > 
> > Sorry Trond,
> > but this is simply not true.
> > 
> > inotify is a key feature at least in some packages I know, and makes
> > some things *a lot* easier.
> > 
> > Of course this are less visible features, that are easy to overlook, but
> > they are not unused for sure.
> 
> So why is it so difficult for anyone in this thread to name these killer
> applications that would benefit from NFS+CIFS support? I keep asking,
> and all I get is wishy-washy and hand-wavy answers.
> 
> Without use cases, there is nothing to discuss on the implementation
> front.

Sorry for the misunderstanding, I wasn't talking about inotify *on
CIFS/NFS*, I do not care about that use case, I'll gladly let Stef pitch
it for himself :)

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

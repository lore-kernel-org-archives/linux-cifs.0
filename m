From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible to make nfs aware of a inotify watch has been set.
Date: Thu, 29 Nov 2012 17:44:04 -0600
Message-ID: <CAH2r5muw1U2XNMZsCq0gApuTMyj+6SN6S9KsUq52YM8CyZEG4A@mail.gmail.com>
References: <CANXojcy9thLBwrENTkOTSSE17L3N17A8XsTmyNqq3oNdhW_Q_w@mail.gmail.com>
	<4FA345DA4F4AE44899BD2B03EEEC2FA90B329CFD@SACEXCMBX04-PRD.hq.netapp.com>
	<CANXojcxR9673fRObMLPSScogAN05RSVhPFoni=ENc6YDWq9T7w@mail.gmail.com>
	<1354202525.4064.1.camel@pico.ipa.ssimo.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA90B32AEB7@SACEXCMBX04-PRD.hq.netapp.com>
	<CANXojcys4wR8N-R3oSjWRWJLsObn0Qf+i41vBUaNnJctdcrKVw@mail.gmail.com>
	<20121129202037.GQ4939@ZenIV.linux.org.uk>
	<CANXojcw15RdJdRoZxB3Z59YbOda7vG7RDRegfpoCjG4Bv4AvsQ@mail.gmail.com>
	<20121129211624.GS4939@ZenIV.linux.org.uk>
	<CANXojcxfrO+Ar4JSd0NiDJh7+_gg6s6cq5=UA7Pu1h4DRZ8Vkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	"Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcxfrO+Ar4JSd0NiDJh7+_gg6s6cq5=UA7Pu1h4DRZ8Vkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 29, 2012 at 5:14 PM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2012/11/29 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
>> On Thu, Nov 29, 2012 at 09:31:05PM +0100, Stef Bon wrote:
>>> 2012/11/29 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
>>> > On Thu, Nov 29, 2012 at 05:39:27PM +0100, Stef Bon wrote:
>>> >
>
>>> With Ubuntu people started Unity, also without a killer app, but just
>>> with an opinion, an impression, an idea. And anyone can dislike or
>>> like it, it's a succes as far as I can see. What the hell is wrong
>>> with suggesting things based upon an idea/impression?
>>
>> IOW, it was a true positive for "([Uu]ser experience)|UX" as BS predictor.
>> Nice to know...
>>
>> Look, you'd been asked to give good reasons for doing some thing; replying with
>> "it's My Opinion(tm), piss off if that's not enough reason for you" would at
>> least have been honest.  References to UX, as your last reply has confirmed,
>> had been basically an obfuscated equivalent of that.
>
> No no, I do not say "piss off". If that is what my message looked
> like, I'm sorry for that. But I do not have any killer app or
> something. I cannot convince you otherwise that saying it's my
> opinion. I do not have numbers or something like that proving I have a
> point. I wish I have. But I do understand you do not agree with me,
> and see things different.
>>
>> Sorry for being harsh, but I've had it with the GNOME crowd and their ilk
>> using just such references to handwave away any questions.
>>
>> There's nothing wrong with having opinions/impressions/etc.  Everyone got
>> their own, etc.  But "I believe so, period" is not a sufficient answer to
>> "what makes that a good idea?" and obfuscating it up is even worse.
>
> So, no I do not say "I believe so, period" . But I cannot convince you
> ...and we have different opinions here.. I don't know any method here
> of "proving having a point".

One question that hasn't been answered AFAIK is how well the current
Linux directory change notification API maps to the needs of its principal user
(presumably Samba, and kde/gnome file managers), and a loosely
related question of how well the change notification API maps to the
corresponding network file system protocol operations
(TRANSACT_NOTIFY_CHANGE) which is a fairly common operation
sent to Samba, and obviously for the cifs/smb2/smb3 case would limit
what types of events the client can notify the desktop/file manager about.

In particular, the 10 or 15 filter flags, and the (at least) 8 events
(add/remove/modify/rename etc.),
available in tne network protocol AFAIK have not been matched to see if they
match closely to the existing Linux API.

-- 
Thanks,

Steve

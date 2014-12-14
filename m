From: Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
Date: Sat, 13 Dec 2014 21:29:10 -0800
Message-ID: <CAJiQ=7APtRLarnAFFaDy1_KgnBN-wcK2=scOP5Ks0v5GH=AR3Q@mail.gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
 <CAJiQ=7C9qV2acVLWjacwsRmGMbyKUqCT5VbnO5TzeLLX73xMaQ@mail.gmail.com> <CAH2r5mteTRPVNTgVxNLqjdzok87HXxhC+xo+tnR3L0DKntSe6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mteTRPVNTgVxNLqjdzok87HXxhC+xo+tnR3L0DKntSe6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 13, 2014 at 9:20 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Probably harmless patch - but I didn't notice the warning on x86
> kernel build (building on Fedora 21, gcc 4.9.2)

Did you test x86 32-bit or 64-bit?  In the generic do_div()
implementation, only the former case has an explicit type check.

FWIW I'm on 32-bit bit MIPS.

From: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Tue, 14 Jun 2011 23:11:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1106142233270.23723@sarijopen.student.utwente.nl>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
 <20110609183045.01f6f9fc@tlielax.poochiereds.net>
 <BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
 <Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
 <20110610073702.061bc014@corrin.poochiereds.net>
 <BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com> <4DF20A97.8010405@suse.de>
 <BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
 <20110611074113.5a05f919@tlielax.poochiereds.net>
 <Pine.LNX.4.64.1106112356500.12565@sarijopen.student.utwente.nl>
 <20110613114831.37c90109@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110613114831.37c90109-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> (cc'ing Pavel)
>
> Ok, I've been able to reproduce on -rc2 as well, simply by mounting
> with -o sec=none. Pavel, I'm pretty sure this got broken by commit
> 724d9f1cfb. That patch doesn't handle the "null user" case correctly.
> There are probably several different ways to fix it:
>

Ave all

Just to confirm the OOPS/BUG is still present in 3.0-rc3

3.0-rc3                  -> same OOPS as in rc1
3.0-rc3+ Jeff's patch    -> same BUG as in rc1

Can I be helpful with further testing by cranking up some more debugging 
options in the kernel hacking section of "make menuconfig", or is the 
cause of the OOPS/BUG clear enough?

Martijn

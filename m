From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS module build verification system
Date: Tue, 19 Aug 2014 00:08:46 -0500
Message-ID: <CAH2r5msm571c4dStXRqeO9MvYGEBhTB6YRBcnqfQELztPuBZXA@mail.gmail.com>
References: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This looks promising ... note the typo ("NFS" instead of "CIFS" in the
error message in the xfstest patch)

+    cifs)
+       # Don't know how to check an NFS filesystem, yet.

On Mon, Aug 18, 2014 at 12:46 PM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
>
> During the second part of the GSoC program of this year I has been
> working on build verification system for CIFS kernel module.
>
> Now, I got the system ready to test module with Cthon and XFS test
> suites. Both suites has some tests (that are not working with CIFS)
> disabled. I was trying to make it easier to add new test suites
> further.
>
> The system is based on bash scripts that can be run from cron. The
> scripts automatically pull the recent changes from the predefined git
> repository, build the module and run tests against it.
>
> The git repo for build verification system scripts:
> http://git.altlinux.org/people/piastry/public/?p=cifs-tests.git;a=summary
>
> The git repo for patched Cthon tests (merged by Steve Dickson into his tree):
> http://git.altlinux.org/people/piastry/public/?p=cthon04.git;a=summary
>
> The git repo for patched XFS tests:
> http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=summary
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve

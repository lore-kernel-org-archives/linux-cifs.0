From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount cifs using SMB2 - Invalid argument
Date: Tue, 10 Jun 2014 12:30:48 -0400
Message-ID: <CAH2r5muFDagMCdb41F7gf2UwsLO3=xyj9nXYQyyr+M2siig_YQ@mail.gmail.com>
References: <A612847CFE53224C91B23E3A5B48BAC7A7A2BE7F5E@xmail3.se.axis.com>
 <CADT32eKz57t-HSadM26EQQtO0u=H02vY9MktMhyu5X+93Vn9FQ@mail.gmail.com>
 <A612847CFE53224C91B23E3A5B48BAC7A7A2BE80A8@xmail3.se.axis.com>
 <CADT32e+eSjr88xoFDSV7cXs+fJdNkXwgPM5CDE4Fj_UUt+Ld3g@mail.gmail.com>
 <A612847CFE53224C91B23E3A5B48BAC7A7A2BE82F0@xmail3.se.axis.com>
 <CAH2r5mtoaKrvG5j_B-eVdCc=MpeZKDH87nT6-N19zN9v0nTafA@mail.gmail.com> <A612847CFE53224C91B23E3A5B48BAC7A7A2BE848E@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Karin Hedlund <karin.hedlund-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC7A7A2BE848E-qSO7W+xaCpBHog8JR6emWdBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jun 10, 2014 at 8:12 AM, Karin Hedlund <karin.hedlund-VrBV9hrLPhE@public.gmane.org> wrote:
> On Jun 10, 2014 12:45, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>On Jun 10, 2014 3:19 AM, "Karin Hedlund" <karin.hedlund-VrBV9hrLPhE@public.gmane.org> wrote:
>>>
>>> On Mon, Jun 9, 2014 at 4:42 PM, Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> vers=2.0 does not work?
>>
>>> Well, actually vers=2.0 does work fine! Thanks for the suggestion! :) I did try it earlier, but probably did not have all the other things in place by then, because I know it didn't work then, but it does now.
>>> I wonder why nothing above vers=2.0 works though, any ideas?
>>
>>The obvious reason would be samba 3.6 on the server instead of samba 4 or later
>
> Ah, ok, I see. I thought the client and server would sort of 'autonegotiate' and agree on the highest version they both support, but I guess that's not the case when using the 'vers' mount.cifs option then? In that case what I'm seeing is very much expected, so I'm very happy now. Thanks for all the support!

We don't autonegotiate smb2 vs. smb2.1 vs. smb3 vs. smb3.02 (yet) -
specify specific dialect on mount.  Not clear if this should be
handled in user space or kernel either (if at all).    On the other
hand, looks like the server does not support smb3 (thus my guess that
you are running an SMB3.6 based, rather than Samba 4.x based filer).

> Any news on the upgrade of the default SMB version of the in-kernel cifs module, by the way?

1) MultiCredit support (faster large file copy) needs to be added
(Pavel is looking at this)

2) Unix extensions (I have a prototype small patch which requests such
support on open, but no server support yet)

>  I found the SDC2013 "SMB3.02 And Linux: A Status Update" presentation (http://www.snia.org/sites/default/files2/SDC2013/presentations/Revisions/StevenFrench_SMB3_Meets_Linux_ver3_revision.pdf), but since it's almost already old by now and I'm curious, I thought I'd ask. :)



-- 
Thanks,

Steve

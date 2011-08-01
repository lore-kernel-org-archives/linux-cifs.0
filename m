From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v5 PATCH 1/5] CIFS: Move buffer allocation to a separate function
Date: Mon, 1 Aug 2011 21:42:33 +0400
Message-ID: <CAKywueS+g18AnsvyVKa3Og31AK0qB8aempu+WF8bzOAwRQa5Xw@mail.gmail.com>
References: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
	<1312190384-3376-2-git-send-email-piastryyy@gmail.com>
	<CAH2r5mvuUPHkBGNKLXAAUsWx5Vv3gmy=hnYM-z48=0sOBaVRnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvuUPHkBGNKLXAAUsWx5Vv3gmy=hnYM-z48=0sOBaVRnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/1 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Revewed and Merged (still reviewing the others).

Ok, thanks!

>
> Any idea why your patches (at least the last few) show up
> with the following checkpatch warning (I don't think
> it is a problem but thought it might be old git tools
> on your system which generated the patch).
>
>
> stevef@stevef-laptop:~/cifs-2.6$ scripts/checkpatch.pl ~/pavel1b.patc=
h
> WARNING: Use a single space after To:
> #36:
> To: =A0 =A0 linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> total: 0 errors, 1 warnings, 153 lines checked
>
> /home/stevef/pavel1b.patch has style problems, please review.
>
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>
>

Strange. I have git of 1.7.1 version but I am not sure it's a problem:
I downloaded the patch from
https://patchwork.kernel.org/patch/1025102/mbox/ and checked it with
checkpatch.pl - no warnings!

--=20
Best regards,
Pavel Shilovsky.

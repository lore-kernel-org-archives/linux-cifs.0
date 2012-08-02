From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling of Connection.CommandSequenceWindow for SMB2 ...
Date: Thu, 2 Aug 2012 12:42:30 -0500
Message-ID: <CAH2r5mtACnkonTfg-haugp4DSQSM2Yb5e-jY+uioPGFhFaMQtw@mail.gmail.com>
References: <CACyXjPzNCR-uF8wUr1Mw-H9S6rma4iLDBW1r01ooncCh=AKHvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzNCR-uF8wUr1Mw-H9S6rma4iLDBW1r01ooncCh=AKHvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most current is:

git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Dshortlog;h=
=3Drefs/heads/smb2-dev

although the smb2-mount branch, which contains few patches, only the
more basic smb2 support,
is the branch we are focusing on for review.

On Thu, Aug 2, 2012 at 8:49 AM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi folks,
>
> I have not been able to find where Connection.CommandSequenceWindow i=
s
> handled in the smb2 code.
>
> Perhaps I am looking in the wrong repos or the wrong branch. Can
> someone point me to where it is?
>
> I am referring to [MS-SMB2] section 3.3.1.7 (dated July 5, 2012.) and
> the other references to the CommandSequenceWindow. I would have
> thought that it might be dealt with in the demultiplexing thread. It
> does not seem possible to avoid explicitly storing the
> CommandSequenceWindow because of the potential for out-of-order
> receipt of SMBs.
>
> --
> Regards,
> Richard Sharpe
> (=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve

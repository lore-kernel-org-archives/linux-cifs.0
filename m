From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: Alternate Data Streams
Date: Mon, 2 Apr 2012 10:21:31 -0700
Message-ID: <CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A@mail.gmail.com>
References: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 4/2/12, Steve French <smfrench@gmail.com> wrote:
> A user was asking about how to query alternate data streams of files
> (over cifs) remotely for backup.
>
> Alternate Data Streams can be read from cifs (e.g.
> /path/filename:streamname) but not listed or created.   Any thoughts
> about whether this (at least listing the streams) should be done via
> an ioctl, xattr or ...?

Well, FindFirstStreamW and FindNextStreamW seem to available from
W2K03 on. There is a code project out there that you can search on. I
hit it as the first link returned when I searched for "Enumerating
Alternate Data Streams"

> How does NTFS-fuse handle this?
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

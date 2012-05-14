From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: failed to fetch the cifs tree
Date: Sun, 13 May 2012 21:52:44 -0500
Message-ID: <CAH2r5mvt2ApHfbT8MbZtdNGnBD+SETY-e8CqmGNYLE-6C-=0Ew@mail.gmail.com>
References: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Should be ok now.

I had to rebuild the for-next branch of cifs-2.6.git due to a problem
caused by a previous "git push --force" (I had already fixed the
master branch of cifs-2.6.git but had not fixed up the for-next
branch).  It is now recreated and some patches from Jeff and Pavel
remerged.

On Sun, May 13, 2012 at 6:54 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> Hi all,
>
> Trying to fetch the cifs tree gets this error:
>
> fatal: Couldn't find remote ref refs/heads/for-next
>
> and checking via "git ls-remote" shows that the remote tree has only =
a
> "master" branch that is set to v3.4-rc7. =A0 Something got lost along=
 the
> way ...
>
> I will use the cifs tree from next-20120511 for today.
>
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug=
=2Eorg.au



--=20
Thanks,

Steve

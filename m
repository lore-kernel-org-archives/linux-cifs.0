From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Wed, 22 Sep 2010 20:32:41 -0500
Message-ID: <AANLkTimXtigjQwpL6i46JTiuREdLnr7Yh+2ZCuPfy06G@mail.gmail.com>
References: <20100923112004.b47923b7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100923112004.b47923b7.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Sorry about that - we merged one of Jeff's patches (in a series) out
of order by three hours due to review comments.  Should be ok now -
verifying.

On Wed, Sep 22, 2010 at 8:20 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/file.c: In function 'cifs_writepages':
> fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named=
 'tcon'
> fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named=
 'tcon'
> fs/cifs/file.c:1366: error: 'struct cifs_sb_info' has no member named=
 'tcon'
>
> Caused by commit 2eff6be391f00d606b43e60d9727b70c44917b7e ("cifs:
> temporarily rename cifs_sb->tcon to ptcon to catch stragglers").
>
> Really, such testing code should not be in linux-next ...
>
> I have used the cifs tree fomr next-20100921 for today.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug=
=2Eorg.au
> http://www.canb.auug.org.au/~sfr/
>



--=20
Thanks,

Steve

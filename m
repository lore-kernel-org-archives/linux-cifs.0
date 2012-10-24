From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Wed, 24 Oct 2012 02:20:10 -0400
Message-ID: <CAFB9KM2bTnsA1jnMR26r+Why=gVNE0qwoaXvbpQfmSZy+yMd=Q@mail.gmail.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
	<5086BE25.8080102@gmail.com> <5086CA29.8030305@steve-ss.com>
	<CAFB9KM26Qk-MC+_w-Q4Rrg3X0nMJ2efS72Y+GjWckgf9g6fzEg@mail.gmail.com>
	<5086EE9C.7030800@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, jlayton@redhat.com, smfrench@gmail.com
To: steve <steve@steve-ss.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <5086EE9C.7030800@steve-ss.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Oct 23, 2012 at 3:23 PM, steve <steve@steve-ss.com> wrote:

> Hi Scott, hi everyone
> Yeah, that's fine.
> Does this clear up the issue with the ':'? I should have made it clearer
> that I was referring to autofs and not mounting e.g. from fstab. I just
> tried the automounter on cifs without the ':' and it doesn't work.
>
> Would it perhaps help to put a message in the logs when it fails, rather
> than silence? Or maybe that's more of a question for the autofs guys.
> Cheers,
> Steve
>

I've been at home thinking about this for a while tonight. I've
checked the documentation for autofs and they do what they say what
they'll do with that path (treat anything without a ':' as an NFS
mount).  On our side, (mount.cifs) we do what we say we'll do (support
UNC paths).  The most we could ask of them is to add/modify their
documentation to include the case for CIFS instead of just SMB.

This doesn't change anything on the mount.cifs side other than
explicitly directing users to the correct syntax for CIFS shares when
using autofs.  Ultimately the autofs documentation implicitly states
that CIFS shares should use a ':'.

All that being said, the mount.cifs has never officially supported NFS
path syntax.  We aren't silently ignoring the issue; we're sending a
warning to stdout that in a future version of the mount utility we
won't support this undocumented behavior.  To be fair, that's more
than most code bases do for deprecating undocumented features.

If anyone wants me to pursue the issue, I'll see what I can do about
getting the documentation for autofs altered to explicitly mention
CIFS paths.  I think that is reasonable for everyone.  It's after 2 AM
in my part of the world, so I'll do this tomorrow after my first cup
of coffee if anyone requests it.

-- 
Peace and Blessings,
-Scott.

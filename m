From: Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 13:36:27 -0400
Message-ID: <20121023133627.798100fb@corrin.poochiereds.net>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
	<5086BE25.8080102@gmail.com> <5086CA29.8030305@steve-ss.com>
	<20121023130238.6100255d@corrin.poochiereds.net>
	<5086D258.1020203@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, smfrench@gmail.com
To: steve <steve@steve-ss.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <5086D258.1020203@steve-ss.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 23 Oct 2012 19:22:32 +0200
steve <steve@steve-ss.com> wrote:

> On 10/23/2012 07:02 PM, Jeff Layton wrote:
> > On Tue, 23 Oct 2012 18:47:37 +0200
> > steve <steve@steve-ss.com> wrote:
> >
> >> On 10/23/2012 05:56 PM, Scott Lovenberg wrote:
> >> Currently, we have this map: * -fstype=cifs,rw,sec=krb5 
> >> ://myserver/myshare/& 
> > Does that really work? What purpose does the ':' serve there?
> Yes. They always put a ':' before the mount except for the default NFS. 
> I took a look at the example /etc/auto.misc which comes (commented out) 
> with openSUSE. They always put a ':'.

Ok, I see now. From autofs(5):

If the filesystem to be mounted begins with a / (such as local /dev
entries or smbfs shares) a : needs to be prefixed (e.g.  :/dev/sda1).

...I guess it's necessary for the autofs parser. I assume that the ':'
doesn't get passed to the actual mount invocation though, so that
should continue to work just fine.

> > That
> > should probably be removed. I doubt we'd end up breaking that syntax,
> > but I can't be certain.
> >
> Just to say that this is a seemingly innocuous patch, but one which may 
> lead to confusion.

Well, better confusion now than confusion when it breaks. cifs really
is just too "loose" about the syntax of things that it accepts, which
sounds great until you have to test all of the different variations...

-- 
Jeff Layton <jlayton@redhat.com>
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba

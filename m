From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2] Convert properly UTF-8 to UTF-16
Date: Mon, 8 Oct 2012 07:26:58 -0400
Message-ID: <20121008072658.0df25c55@tlielax.poochiereds.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net>
	<20120807064752.22e0da81@corrin.poochiereds.net>
	<7CE799CC0E4DE04B88D5FDF226E18AC2E07634EB82@LONPMAILBOX01.citrite.net>
	<7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408DA@LONPMAILBOX01.citrite.net>
	<CAH2r5msLxJVTwVrD9vs8ZOjQdRpbVyhZus4V6Su-Y8-hT229Ug@mail.gmail.com>
	<7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408E8@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "smfrench@gmail.com" <smfrench@gmail.com>,
	"sfrench@samba.org" <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408E8@LONPMAILBOX01.citrite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 8 Oct 2012 09:18:06 +0100
Frediano Ziglio <frediano.ziglio@citrix.com> wrote:

> On Wed, 2012-10-03 at 14:49 -0500, Steve French wrote:
> > Merged - but doesn't the reverse also have to be added in cifs_from_utf16?  ie
> > 
> >           utf16s_to_utf8s(uni, ... );
> > 
> 
> Not strictly necessary, at least to be able to mount shares.
> 

It probably is necessary if you want to be able to do anything
involving these filenames...

> > I am glad that someone added these multiword handling routines into
> > the kernel for FAT - this has been something we have wanted for a long
> > time in cifs (and smb2/smb3).  Note the comment in
> > fs/cifs/cifs_unicode.c
> > 
> > / * Note that some windows versions actually send multiword UTF-16 characters
> >  * instead of straight UTF16-2. The linux nls routines however aren't able to
> >  * deal with those characters properly. In the event that we get some of
> >  * those characters, they won't be translated properly.
> >  */
> > int
> > cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
> >                  const struct nls_table *codepage, bool mapchar)
> > 
> 
> Should not be UCS-2 instead of UTF16-2 ??
> 
> > 
> > We could really use some nls test cases for cifs/smb2/smb3/nfs4 which
> > basically did various file, directory, symlink create/rename/delete
> > operations with various hard to map characters so we can test copying
> > to and from the server and ensure that we get the name mappings right
> > for these (and don't ever regress).   Fortunately smb2/smb3 is only
> > unicode so we don't have to deal with mappings to other codepages from
> > utf8
> > 
> 
> Do you have some framework/hook to put these tests ?
> 
> Where did you merge ? I cannot find nothing at
> http://gitweb.samba.org/?p=sfrench/cifs-2.6.git;a=summary
> 
> Regards
>   Frediano
> 

-- 
Jeff Layton <jlayton@redhat.com>

From: Jeff Layton <jlayton@samba.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
	register them
Date: Fri, 25 Jun 2010 18:26:51 -0400
Message-ID: <20100625182651.36800d06@tlielax.poochiereds.net>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>
	<4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes>
	<9822.1277312573@redhat.com> <22697.1277470549@redhat.com>
	<18628.1277502398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
	linux-fsdevel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <18628.1277502398@redhat.com>
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

On Fri, 25 Jun 2010 22:46:38 +0100
David Howells <dhowells@redhat.com> wrote:

> Jeff Layton <jlayton@samba.org> wrote:
> 
> > Looks like it mostly uses the ctime. IMO, the mtime would be a better
> > choice since it changes less frequently, but I don't guess that it
> > matters very much.
> 
> I'd've thought mtime changes more frequently since that's altered when data is
> written.  ctime is changed when attributes are changed.
> 

IIUC, updating mtime for a write is also an attribute change, and that
affects ctime. According to the stat(2) manpage:

       The field st_ctime is changed by writing or by setting  inode  informa-
       tion (i.e., owner, group, link count, mode, etc.).

> Note that Ext4 appears to have a file creation time field in its inode
> (struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?
> 

Is it exposed to userspace in any (standard) way? It would be handy to
have that. While we're wishing...it might also be nice to have a
standard way to get at the i_generation from userspace too.

-- 
Jeff Layton <jlayton@samba.org>

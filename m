From: Jeremy Allison <jra@samba.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Fri, 18 Jul 2014 10:09:52 -0700
Message-ID: <20140718170952.GA27001@samba2>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Jul 18, 2014 at 01:15:07AM -0500, Steve French wrote:
> I created a patch to cifs.ko to add fallocate FALLOC_FL_KEEP_SIZE
> support and did some tests against a Samba server (Samba 4.1.6 on ext4
> on Ubuntu) and also a Windows 8.1 server (NTFS file system) and ran
> into an obvious problem.  How to tell if the allocation size is
> changed?  Neither stat on the Samba server local file system nor the
> Windows 8.1 properties show the size on disk changing.
> 
> I am sending SMB3 SetInfo level 0x13 (set allocation size) and getting
> success back from the Windows server and from Samba server.
> 
> If I set the length past the end of file I get no error, but the
> properties of the file in Windows Explorer still show the same (e.g.
> zero) as the file size.  If I try setting it to a size smaller than
> the size of the file, the file shrinks (by the way this is an awkward
> behavior to work around since on Linux fallocate can't shrink the file
> - so if you have any ideas short of revalidating the file size before
> deciding whether to send the fallocate request to Windows ...).
> 
> Any ideas why Samba shows success but doesn't actually call ext4 to
> update the allocation size?

smbd does use VFS_FALLOCATE_KEEP_SIZE, which maps
into fallocate FALLOC_FL_KEEP_SIZE if the underlying
storage supports it.

You need to set "strict allocate = true" on the
share in order to get this behavior though.

If you're setting allocation size smaller
than file size we just use ftruncate, I
don't see another possibility here. What
behavior do you expect in the shrink case ?

Jeremy.

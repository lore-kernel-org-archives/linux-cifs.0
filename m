From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH v2 1/3] generic/013: encapsulate remount during cleanup
Date: Thu, 28 Aug 2014 22:50:36 +0400
Message-ID: <5F4BB2B2-2286-4EC0-B70C-F5BC107DA513@gmail.com>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org> <1409084918-17764-2-git-send-email-pshilovsky@samba.org> <20140828170849.GA20891@infradead.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=koi8-r
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, Steve French <smfrench@gmail.com>,
	Pavel Shilovsky <pshilovsky@samba.org>, "samba-technical@samba.org" <samba-technical@samba.org>, David Disseldorp <ddiss@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20140828170849.GA20891@infradead.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org



>> 28 =C1=D7=C7. 2014 =C7., =D7 21:08, Christoph Hellwig <hch@infradead.org>=
 =CE=C1=D0=C9=D3=C1=CC(=C1):
>>=20
>> On Wed, Aug 27, 2014 at 12:28:36AM +0400, Pavel Shilovsky wrote:
>> The existing code calls remount for $TEST_DEV with constantly defined
>> mount options. This can fail if a user specifies different mount options.=

>> Fix this by using new _test_remount() call that remounts $TEST_DEV.
>=20
> Looks technically correct, but I still wonder why it's needed at all,
> I can't see anything in the test that would remount the filesystem
> read-only.  git history isn't a help here as the remount goes back to
> the first public revision.

Anyway I think it won't hurt to apply this patch at first and then probably r=
emove this part at all.

--
Best regards,
Pavel Shilovsky.=

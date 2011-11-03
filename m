From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 3 Nov 2011 23:25:12 +0000
Message-ID: <A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
	<20111103134056.178ee9e3@barsoom.rdu.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
	Unix Support <unix-support@ucs.cam.ac.uk>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20111103134056.178ee9e3@barsoom.rdu.redhat.com>
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

Hi,

On 3 Nov 2011, at 17:40, Jeff Layton wrote:
> On Thu, 3 Nov 2011 15:42:13 +0000 Anton Altaparmakov <aia21@cam.ac.uk> =
wrote:
>>=20
>> I should add that we are using iocharset=3Dutf8 mount option which =
means that the dcache hash/compare functions done in the cifs module do =
not work because it uses nls_tolower() and nls_strnicmp() both of which =
for utf8 NLS in the kernel do not do anything at all and effectively =
behave case sensitively!
>>=20
>> Thus this bug/problem in all likelyhood only affects utf8 iocharset =
users on a case-insensitive but case-preserving CIFS server that does =
not support server inode numbers.
>>=20
>> That probably explains why it has not been noticed before!
>>=20
>> We need utf8 thus we still need to fix this issue.

> I'm confused...
>=20
> If the filesystem being served out by the server is using utf8, then
> how is it handling the case-insensitivity?


The file system being served is NSS (the Netware one but now mounted on =
Open Enterprise Server with Linux kernel rather than actual Netware =
kernel).  No idea how it works I am afraid.  It supports lots of =
different namespaces as well as being case-insensitive and case =
preserving when using the LONG name space (which is now being served =
through CIFS).

If it was NTFS or exFAT I could tell you exactly how they work (each =
volume has an upcase table mapping the 65536 UCS-2 Unicode characters to =
their upper case equivalents and each 16-bit character is upper-cased =
individually, more recently Windows has switched to using UTF-16 instead =
of UCS-2 and the upcase table changed when that happened though it =
remained the same size and I think for file system purposes the fact =
that there are surrogates in the above UCS-2   Unicode range is simply =
ignored)...

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

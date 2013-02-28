From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 23:54:13 +0100
Message-ID: <E1UBCMh-00FRaK-CC@intern.SerNet.DE>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512E8787.6070709@canonical.com>
	<20130228072637.3b71a4f7@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
	"Stefan \(metze\) Metzmacher" <metze@samba.org>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Dave Chiluk <dave.chiluk@canonical.com>,
	Dave Chiluk <chiluk@canonical.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20130228072637.3b71a4f7@corrin.poochiereds.net>
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

On 2013-02-28 at 07:26 -0800 Jeff Layton sent off:
> NTFS doesn't support sparse files, so the OS has to zero-fill up to the
> point where you're writing. That can take a looooong time on slow
> storage (minutes even).

but you are talking about FAT here, right? NTFS does support sparse files=
 if
the sparse bit has been explicitly been set on it. Bit even if the sparse=
 bit
is not set filling a file with zeros by writing after a seek long beyond =
the
end of the file is very fast because NTFS supports that feature what Unix
filesystems like xfs call extents.

If writing beyond the end of a file is really slow via cifs vfs in the te=
st
case against a ntfs volume then I wonder if that operation is being reall=
y done
optimally over the wire. ntfs really isn't that bad with handling this ki=
nd of
files.

Cheers
Bj=F6rn

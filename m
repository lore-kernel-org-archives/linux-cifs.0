From: Jeff Layton <jlayton@samba.org>
Subject: Re: cifs and Netapp DFS-shares problems
Date: Fri, 10 Dec 2010 06:34:49 -0500
Message-ID: <20101210063449.5ab06c5f@tlielax.poochiereds.net>
References: <1291855039.11237.49.camel@kramer>
	<1291976746.8971.24.camel@kramer>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org
To: lists@localguru.de
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <1291976746.8971.24.camel@kramer>
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

On Fri, 10 Dec 2010 11:25:46 +0100
Marcus <lists@localguru.de> wrote:

> Hi,
> =

> Am Donnerstag, den 09.12.2010, 01:37 +0100 schrieb Marcus:
> > =

> > are there any known issues with cifs and DFS-shares on Netapp file
> > servers? We have a Netapp file sever with DFS on the user's home shares.
> > The home shares can successfully mounted with
> > =

> >   mount -t cifs //sever/home/username /mnt/ -o user=3Dusername,domain=
=3DAD
> > =

> > but the connection hangs in the moment a directory listing is started.
> > The strange thing is that only shares with activated DFS show this
> > problem. I'm not maintaining the Netapp file server therefore a can't
> > post more information about that system. On client side I'm using Ubuntu
> > LTS 10.04.1.
> =

> This error only comes up, if DFS is activated on a share on the NetApp
> Server. Here is a kernel log:
> =

> Dec 10 11:10:37 lebowski kernel: [ 3586.471662] Bad SMB: : dump of 48
> bytes of data at 0xe44e5c00
> Dec 10 11:10:37 lebowski kernel: [ 3586.471675]  0000009a 424d53ff
> 00000032 80018800 . . . . =FF S M B 2 . . . . . . .
> Dec 10 11:10:37 lebowski kernel: [ 3586.471688]  00000000 00000000
> 00000000 26420040 . . . . . . . . . . . . @ . B &
> Dec 10 11:10:37 lebowski kernel: [ 3586.471701]  001a0800 7000020a
> 02000000 00003800 . . . . . . . p . . . . . 8 . .
> Dec 10 11:11:03 lebowski kernel: [ 3612.832108]  CIFS VFS: server not
> responding
> Dec 10 11:11:03 lebowski kernel: [ 3612.832125]  CIFS VFS: No response
> for cmd 50 mid 26
> Dec 10 11:11:05 lebowski kernel: [ 3614.656937]  CIFS VFS: RFC1001 size
> 154 bigger than SMB for Mid=3D30
> Dec 10 11:11:05 lebowski kernel: [ 3614.656953] Bad SMB: : dump of 48
> bytes of data at 0xe44e5c00
> Dec 10 11:11:05 lebowski kernel: [ 3614.656967]  0000009a 424d53ff
> 00000032 80018800 . . . . =FF S M B 2 . . . . . . .
> Dec 10 11:11:05 lebowski kernel: [ 3614.656979]  00000000 00000000
> 00000000 26420040 . . . . . . . . . . . . @ . B &
> Dec 10 11:11:05 lebowski kernel: [ 3614.656994]  001e0800 7000020a
> 02000000 00003800 . . . . . . . p . . . . . 8 . .
> Dec 10 11:11:33 lebowski kernel: [ 3642.832284]  CIFS VFS: server not
> responding
> Dec 10 11:11:33 lebowski kernel: [ 3642.832299]  CIFS VFS: No response
> for cmd 50 mid 30
> Dec 10 11:11:40 lebowski kernel: [ 3649.895000]  CIFS VFS: RFC1001 size
> 154 bigger than SMB for Mid=3D34
> Dec 10 11:11:40 lebowski kernel: [ 3649.895017] Bad SMB: : dump of 48
> bytes of data at 0xe44e5c00
> Dec 10 11:11:40 lebowski kernel: [ 3649.895030]  0000009a 424d53ff
> 00000032 80018800 . . . . =FF S M B 2 . . . . . . .
> Dec 10 11:11:40 lebowski kernel: [ 3649.895043]  00000000 00000000
> 00000000 26420040 . . . . . . . . . . . . @ . B &
> Dec 10 11:11:40 lebowski kernel: [ 3649.895056]  00220800 7000020a
> 02000000 00003800 . . " . . . . p . . . . . 8 . .
> --------------------------
> =

> umounting is impossible and gives the following error:
> =

> --------------------------
> unmount error 16 =3D Device or resource busy
> Refer to the umount.cifs(8) manual page (man 8 umount.cifs)
> unmount error 16 =3D Device or resource busy
> Refer to the umount.cifs(8) manual page (man 8 umount.cifs)
> --------------------------
> =

> Any ideas? Seems to be an error of the NetApp Fileserver acting not RFC
> conform.
> =

> Is this the right list to discuss or should I post on linux-cifs-client
> list?
> =

(cc'ing linux-cifs mailing list)

Probably because the ls is hung and is holding references to the mount...

I've successfully tested against netapp's CIFS implementation in the
past, but there are significant bugs in it. The errors you're seeing
look like an alignment problem of some sort -- i.e. the server is
sending packets that have incorrect length fields in them. This isn't
the first such problem I've seen with OnTap.

You're welcome to open a bug at bugzilla.samba.org, cc me, and I'll
take a look when I have time. Gathering wire captures during one of
these events and attaching them to the bug would help to track down the
problem. It's likely to be Netapp's bug however...

-- =

Jeff Layton <jlayton@samba.org>
-- =

To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba

From: Steve French <smfrench@gmail.com>
Subject: Re: CIFS with multiple inodes referring to the same
 server object? [was Re: BUG while pushing to git on cached CIFS]
Date: Wed, 21 Jan 2015 09:07:35 -0600
Message-ID: <CAH2r5mvj2rPsDaMMNxZ+Va9ZQ_9gJnQA27u3duMZD+_OH27P0Q@mail.gmail.com>
References: <12583715.TUUIvBHKl1@ws-stein>
	<6055.1421852678@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, linux-cachefs@redhat.com,
        Alexander Stein <alexander.stein@systec-electronic.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-cachefs-bounces@redhat.com>
In-Reply-To: <6055.1421852678@warthog.procyon.org.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cachefs>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Sender: linux-cachefs-bounces@redhat.com
Errors-To: linux-cachefs-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

Do you know if it is reproducible?
On Jan 21, 2015 9:04 AM, "David Howells" <dhowells@redhat.com> wrote:

> Alexander Stein <alexander.stein@systec-electronic.com> wrote:
>
> > I currently run on a BUG while I was pushing to a bare git repository
> > located on a CIFS which was cached localy. The used kernel is
> 3.18.3-gentoo
> > which this dmesg output:
> >
> > CacheFiles:
> > CacheFiles: Error: Unexpected object collision
> > CacheFiles: object: OBJ1c
> > CacheFiles: objstate=LOOK_UP_OBJECT fl=8 wbusy=2 ev=0[0]
> > CacheFiles: ops=0 inp=0 exc=0
> > CacheFiles: parent=ffff8800d9d96140
> > CacheFiles: cookie=ffff8800d03bd230 [pr=ffff8800cc1ca000
> nd=ffff8800cb4a2490 fl=27]
> > CacheFiles: key=[8] '40a0080501090000'
> > CacheFiles: xobject: OBJ1a
> > CacheFiles: xobjstate=WAIT_FOR_CMD fl=38 wbusy=0 ev=0[6d]
> > CacheFiles: xops=0 inp=0 exc=0
> > CacheFiles: xparent=ffff8800d9d96140
> > CacheFiles: xcookie=ffff8800d03bd190 [pr=ffff8800cc1ca000
> nd=ffff8800cb4aad00 fl=22]
> > CacheFiles: xkey=[8] '40a0080501090000'
>
> It would appear that the cifs filesystem here has two inodes:
>
>         CacheFiles: cookie... nd=ffff8800cb4a2490 ...
>
> and:
>
>         CacheFiles: xcookie... nd=ffff8800cb4aad00 ...
>
> that refer to the file objects with the same cifsi->uniqueid.
>
>         CacheFiles: key=[8] '40a0080501090000'
>         CacheFiles: xkey=[8] '40a0080501090000'
>
> both objects appear to be live or becoming live.  Object flags:
>
>         fl=8: IS_LIVE
>         fl=38: IS_LIVE | IS_LOOKED_UP | IS_AVAILABLE
>
> Cookie flags:
>
>         fl=27: LOOKING_UP | NO_DATA_YET | UNAVAILABLE | ENABLED
>         fl=22: NO_DATA_YET | ENABLED
>
> I can't tell from this whether both inodes refer to the same remote file,
> or
> whether the server is serving out distinct remote files with the same
> uniqueid.
>
> David
>

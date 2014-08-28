From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH v2 2/3] common: add cifs support
Date: Thu, 28 Aug 2014 23:08:39 +0400
Message-ID: <7D0F9460-0B84-4D36-B499-83DA9C334198@gmail.com>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org> <1409084918-17764-3-git-send-email-pshilovsky@samba.org> <20140828171802.GB20891@infradead.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=koi8-r
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, Steve French <smfrench@gmail.com>,
	Pavel Shilovsky <pshilovsky@samba.org>, "samba-technical@samba.org" <samba-technical@samba.org>, David Disseldorp <ddiss@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20140828171802.GB20891@infradead.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

>> 28 =C1=D7=C7. 2014 =C7., =D7 21:18, Christoph Hellwig <hch@infradead.org>=
 =CE=C1=D0=C9=D3=C1=CC(=C1):
>>=20
>> On Wed, Aug 27, 2014 at 12:28:37AM +0400, Pavel Shilovsky wrote:
>> +    - You can explicitly specify NFS or CIFS, otherwise the filesystem t=
ype will
>> +      be autodetected from $TEST_DEV:
>>      ./check -nfs [test(s)]
>=20
> Can you take care of mentioning tmpfs as well, looks like it didn't get
> added here when support was added.

Ok, will add it.

>=20
>>   ;;
>> +    cifs)
>> +    # Don't know how to check a CIFS filesystem, yet.
>> +    ;;
>=20
> Will we ever find a way to sanity check a cifs fs? :)
>=20
> Otherwise looks fine to me.

Probably some day we will be able to run fsck checks on the remote server th=
rough a specific rpc.

Thank you for the review - will repost the series.

--
Best regards,
Pavel Shilovsky.

Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11012012.outbound.protection.outlook.com [40.107.193.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7831F0E33
	for <linux-cifs@vger.kernel.org>; Tue, 25 Mar 2025 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.193.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742937900; cv=fail; b=Q8lv2SWWoUHSjufyUUH+vF6z2IMTcy5Wkef8aZP9mu7pfQI9UoLVOhA2IayQyghndCB+5NbHIhrjnp5VFIGqD0To2Tao6EOEEULmzH26Rm3RyPco35nZCZAw4IlPziGRyw8JnlHTn24EBZdTLXHDmtAqeXSO1V+7Rd89DxBalNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742937900; c=relaxed/simple;
	bh=1i+OZ3R8vqS6Me/yPqRJgCTxDz7tf+5owpPQuUBmDw8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Q0T9MFeEpw+1UPGwngWVAd9ZlHiI0AVzrJ8euLDRNMcEgf7Mlxt9hz+A9rYmKlI/+w53z/TfItUo7PKg+BnY4/yfS8hq1E2nmfvOgAJ3ssqa/GP7IUOD/V4I1eLDoYMalwVC2seDUK7QzH56DT4fu36j0/BPvlu8cHgeJA2r3Tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com; spf=pass smtp.mailfrom=opentext.com; dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b=W5yYofqS; arc=fail smtp.client-ip=40.107.193.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opentext.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b="W5yYofqS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MDIoyhFDk6Qt0OW0oQmTA6Eqm8Jv2fKPiQvDgyREtAu+Zco0nnqwmUD+J3rZtTf/rABdlcEYEPZUptyazMiAmEgkVlGc1PAsgYc0uGrCQxR0oGccmYx5MWrJsJruwm5W0H2/zEmc7bO61Cp/MnFUJEo1R96620/6Uuv6tzJjkdsiUXwzXJhQw6fC3cXVpQtupIq2uJGsAGmuG2dFKuiV2UsPYOqeKbwXwp5X1GJaTcP4CJ4elClqhWZn+KTQYx2v9Xgy1opBEPWHdCgwPptWxo69ZmCLyT/w43l/0FfnWKODElTiZfHZPnmhbUZNw1q9CmpeaC9MbNfGrZeigJAn2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmxTc2099XkRnlBMbhvMoGC6db8qbPkhEf96aKxNUqs=;
 b=AEpHoVSulMSYAk2DZK+HcDL0lWBBn2M9ZpmTSokoA6Qrq7obZLQ8+8irxSbIfZl4dLVWWtMzRn6czScl5+r/JjBE74Jtq2EQwlNUkagUBuXzQOwxPhd6Ha6pXUYKWoelvIgEePYvKO2m/p5woUSBpzyvjGkdsWfEnfGNW/nEWBLhNVN6KdVKGzfFL+DXzKcXptfiwniVLusfflOMtRy1H0jjDFZZTcW/odMf/n/knDw3KrwictsTEpK42A3OFvgcWuuqTo55zoJNUShqswk2TZ/KZ1COkKcPXNoGU/o9tLYENrF1gI3Q5+t0XNC/b45beqkuOWRJ8kbv2ihjAyYU9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opentext.com; dmarc=pass action=none header.from=opentext.com;
 dkim=pass header.d=opentext.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=opentext.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmxTc2099XkRnlBMbhvMoGC6db8qbPkhEf96aKxNUqs=;
 b=W5yYofqSJfgd5dSxbtAeZqEm8qgPkjOeKm0mO5UazzWaf+c2/0+QriNQm6yBtgctLc8vkRJA4YsxyeoBtQMze6Ud17LJHOkwwcYfKalKTTf/ntU8AKqD5TrS8C8UwxVrF2EfqN1/ZtHrXRXYvw4OPd982+5mz7LUBg8KwopKC28=
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:aa::5)
 by YT2PR01MB9571.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 21:24:55 +0000
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d]) by YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d%5]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 21:24:55 +0000
From: Mark A Whiting <whitingm@opentext.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: [BUG REPORT] cifs/smb data corruption when writing, x86_64, kernel
 6.6.71
Thread-Topic: [BUG REPORT] cifs/smb data corruption when writing, x86_64,
 kernel 6.6.71
Thread-Index: AdudzFmZYMLtC4Y+RNm+sf4/yE+hZg==
Date: Tue, 25 Mar 2025 21:24:55 +0000
Message-ID:
 <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opentext.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT1PR01MB9451:EE_|YT2PR01MB9571:EE_
x-ms-office365-filtering-correlation-id: bf337ca5-cad6-48bb-1a6d-08dd6be37ceb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?JgBMYTbhtlpCcGJYaLD9zTHOwKAyi0F20TCYEk4JSwW54N2doRtR/7rAEwNV?=
 =?us-ascii?Q?Xh6ejQZk9g1J0aOt4LKqp3dbl8qpFMEXp01QNkaaGpJ5Up1xA3NRM55QxOq8?=
 =?us-ascii?Q?CQnmYwl8a1tCc8mVf8BsZ9X/uB7mRIx6jA3gQ6q6Iu6fw5y0dyGaNEbwYOKb?=
 =?us-ascii?Q?18Gu6d7nIfNEVKovwl3fRv1YW/a1jeAWhN/Dqg80cVbkIPvlOA5dEvHsKL9Y?=
 =?us-ascii?Q?V/wPrE0qbaJZiDMsGY7uOw53nAsfg0GOJ5K76PLRua73iYpT4uO0oxHczGj3?=
 =?us-ascii?Q?ZIn6ddt6ms0UDd3pjFYDKzMDqHxrrt8QRoJ84qqhxbfaUlhNWzbSdnwsRoJP?=
 =?us-ascii?Q?idcjy5hciqma6IRE6e19H46MJzug8JUSVA0yQi07x81Le7GtiDpZ4aXbU778?=
 =?us-ascii?Q?waBG9SOymb3acOWsEVupE8s9UBtbZQes/oG3iPnLI08uRjitsBJFxCbTs71p?=
 =?us-ascii?Q?ie/KH6t+9vC4riyjctn0tP2nae7k0eFP6fkKZ+WAbm5uM4Mt5TRqYY7cBKGi?=
 =?us-ascii?Q?vSR689UR1MprOqLvfn4bAACmv4iONY89E2WiRAAB5i0PotGr/BnKv7g+ofFo?=
 =?us-ascii?Q?WbKB/knn0hF+bh/XvoEPxJRuI9VYbh77MUY8PPfTXlau5wdO43kwt2TNtK4z?=
 =?us-ascii?Q?FHRiLsSs3A5IxGMuS/kVkbZcrJeR728jSa0gTuwiK9lgvo3xnj9T/mvlzat+?=
 =?us-ascii?Q?yLIA5eF/W35sb7T9vqebtf6BYC89+cZtxRw5jwQMjwNB3obcVv7uen54GQJo?=
 =?us-ascii?Q?l8V8OzAk+S2xDDzNYgHA3rtEGneBgEsKBbe4wYcAV70jM5/958uR6NmTF3q+?=
 =?us-ascii?Q?EzHgMbmf/KTjM2cToZZuBe3+trKdp9/2WyDM3UAmx+gfF9qfm+hwEb5SDTEG?=
 =?us-ascii?Q?uLuKyo6Eak4pw1NzL3a+N/P4tItPVTcQtFia1MAM27Y+OOYzLE8jFIJCqhg3?=
 =?us-ascii?Q?LD+4D5s5aCtwvcIymOSJMB1VggUHuEHCqDUMigiKryo8O4YW4Gnc7axq2xfu?=
 =?us-ascii?Q?MIXT2ki4vqtLT/h7zQp10GltLvi4LirIIYEY1ia+w9lTIHb+2AnFrrlwWMJ0?=
 =?us-ascii?Q?x7fNqckQI3abLgHpgw65263+mTSsPeUvRnf8SIYXMB7o1PksMPkBBuHLKjF0?=
 =?us-ascii?Q?N9P+K5AQ5a69qTIue+D0Tlporf9kpEKjR3FX7LT+vUCrkA/4Y2BzLXKtJ1ik?=
 =?us-ascii?Q?+lyiwKtgiLf0tLxwIspYJdpRp3Gk0BkIZ59cF1CT/F5mOi6zfaMlYcfEDSPr?=
 =?us-ascii?Q?d+HIiYhOnxV/4AgPzPAdMrdGBc8MrtSNlJD2L+SOIiKQDFWNTLH0XaMvvRDS?=
 =?us-ascii?Q?TTfci+c4jzFBdKnJhbGI/XFb7VJzCprx5gEaHL2bNMklTVD8iymmmgKdcsm1?=
 =?us-ascii?Q?+xd1MwypZX+9FtDnMtjjIOCay01W4zSkB4zCUwcSL1TYIKND1VpAeulQhENS?=
 =?us-ascii?Q?azuOhH4I4q8YE6Swlr3+Ygu3Grf76y2M?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UlOMCghv0RnrZscyR0kko/iCWx35bWwItjJBEPNwJ5e+PtaQNwAtKGVMv8iG?=
 =?us-ascii?Q?1KeKIwtHJLJ5cQ59AZ+VlIcMGyh23JSpeuMn9EhHqUDoXkmRLoGxBwFRrBvz?=
 =?us-ascii?Q?+0vJHAJyz4ALyHzEV7oZ3lQ1QIRrhmTFA6uoj+FduY1VVny1dNSfj7MBLjNj?=
 =?us-ascii?Q?yYimkSdqzS4erEb0w8LztcSsUQq+gcRMSGdu8wk2uspcadke27IfoLgiQK9V?=
 =?us-ascii?Q?b0y1+9W9Dn9MNJXLZlm+YxTGSxDQkatSM35PlNQQJkrLqC/DyiEH1PPbkmIL?=
 =?us-ascii?Q?NKpNUwWeN9ppoHS+dlvyFqMDCg3Dgtv7faACKK6pqbQnKMVTvFqHQiNkZNDk?=
 =?us-ascii?Q?kg/rnycwUMbQQDiWRayW974fkNTzGvqTVVmpoHuWuheDMGBfL3NhlkHepOWs?=
 =?us-ascii?Q?5En3CH4wHcgE5RFBXunvfKlTG+JsQdLL4TmyNxtrKp+UVcQ0sAJy3up1XnVO?=
 =?us-ascii?Q?Hqm55MgOBjoZZrq4+SLtzpjOnUm41df+YjgbMMh9xbgd9ndiOtyN+lpzuKHW?=
 =?us-ascii?Q?8w0E+cg67EhB41z4BOMdIbOdeUZlfVVGPeYG02rG4WJgq5jMrpRrW3vrtSnV?=
 =?us-ascii?Q?SJX7XLoyIFXd4sr8/1jAQH8fkf3CQ31ZhJUEbGtBymMbsLU+j9QZ7qiZ2hpx?=
 =?us-ascii?Q?DQnnuBYaFX4J28FYWzfKEZILq9+tij/SqomAkLk9nsSWW9iy7VNoqaTOWczZ?=
 =?us-ascii?Q?Y67rdXm7XcaZ2srPhxoZbYpBlOX3s5K+QAFOZfTHhZmkhslBfLox8gvj/i4c?=
 =?us-ascii?Q?GPj1KKOlz53pqpyAw8kyua7DpfioKvtmgFP1D80cU5X+U92I4v9FuWRaprfA?=
 =?us-ascii?Q?LfJEDPBNHayXsOxkMJfBBL4e0qAtAPyShdVfE28QjjKB5E5SFBN6spOPr+S/?=
 =?us-ascii?Q?k/sGLoNUPBaDWL7gGwh4iSzSUpB+3ecZduykwyJxOWPkDeVjcbsz8UQimrWc?=
 =?us-ascii?Q?7syZfkm6fg6aRwuLMsAhWjVoOjrkpyu9NWLwdta4NRI1xqmUzoTVCyNt2Qw5?=
 =?us-ascii?Q?jqP31NEiYac30yTee+WN9j4FBvrn2G6KElJ5c4gllVBH0NWQPs+/UrHSDnit?=
 =?us-ascii?Q?wnwL9Soh4EjZTKw061oIn/FksgrtzX6nLrjqJLRjeSIdEfV2FGMz3/rffzhO?=
 =?us-ascii?Q?+l4A6Bg5lHH08BsLa26r3TxjefOIsc1RgMWfptMB8TfVm5KlCb6fvc/D5pa/?=
 =?us-ascii?Q?gOW0INW2ubLWOkdm6GSSelKU6RNwdxSGPTwHx4BtYDOrCv1wweXTNwEvgs83?=
 =?us-ascii?Q?Oi9dihk9TzWQj5wpwKhEyTUMw4nwTTzU9U06HK1OIDeI/AHYWgPyklwpgwQl?=
 =?us-ascii?Q?Hv7RtfT4PohkelgxOIMIqCNA9Dw6z/H0WbqiVD0LQBeyXOAbKdaqQUCBoy5w?=
 =?us-ascii?Q?4UUhfbr5ZsMq4Cwngf8XwEq+j3Ew8ixLG1DL/lj6trKuILbFVkFfBTZr4VOA?=
 =?us-ascii?Q?Y3hr6U7gslXOWcaKqODme+IyeOHzu3unhSVPGF9NPwJtWGC4zX4P3p4oWvz7?=
 =?us-ascii?Q?Gakdh4A6cnAENNkLwrjC9wAujDbdn3/PWeG1Sv9aGxSBM9+/BjPWEUOlIcJN?=
 =?us-ascii?Q?liG54Hi2t4h4Xq7YpQN9rSVcZ2tEKxc0Lgd48EbW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: opentext.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bf337ca5-cad6-48bb-1a6d-08dd6be37ceb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 21:24:55.3640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 10a18477-d533-4ecd-a78d-916dbd849d7c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uCKQtfkbfZKAVgrlESjYBdjk7dQ88DVOw6R0lMBzj8PwhUfwqllxfb15xHb/h4PrN9DeUJzleLbZ1WS5NcTLjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB9571

Hello,

I have discovered a data corruption issue with our application writing to a=
 CIFS share. I believe this issue may be related to another report I saw on=
 this mailing list, https://lore.kernel.org/linux-cifs/DFC1DAC5-5C6C-4DC2-8=
07A-DAF12E4B7882@gmail.com/. I understand that updating to a newer kernel w=
ould likely fix this issue. However, at the moment, that's not an option fo=
r us. In the long term we are looking to upgrade to 6.12 but I'm hoping to =
find a solution for our current 6.6 kernel.

I have tested mounting with the "cache=3Dnone" option and that solves the p=
roblem, albeit with a very large performance hit.

The platform is an embedded system. We're using an off-the-shelf COM Expres=
s Type 7 module with an Intel XEON D-1713NT processor. We're running a cust=
om Linux system built using Buildroot, currently running the 6.6.71 kernel.=
 I've tested the latest 6.6.84 kernel and the problem still exists there. O=
ur application is writing large amounts of compressed data (4+ GB) to the n=
etwork share. When I read back the data to verify it, I'm seeing small port=
ions of the file that have been replaced with zeros.

I've attacked the issue from several angles. Starting with a TCP dump of a =
complete operation from mounting, data transfer, to unmounting the network =
share. Through Wireshark I can see that there is no write command to the se=
rver covering the sections of the output that ends up as zeros. This indica=
ted to me that the CIFS kernel driver is failing to write out portions of t=
he file.

I then enabled all the CIFS debug info I could via cifsFYI and the kernel d=
ynamic debug controls and tweaked the code to not rate limit the pr_debug c=
alls. I could trace through the resulting logs and find pairs of cifs_write=
_begin() / cifs_write_end() that covered all the data including the section=
s that ultimately don't get written out. However, tracing through the smb2_=
async_writev() messages I again could not find any writes that covered the =
corrupt portions. At this point I began to suspect some kind of race condit=
ion within the cifs_writepages() function.

I also analyzed the data corruption and noticed a pattern. It does not fail=
 100% of the time, and it does not always fail in the same place. This furt=
hered my belief that it was some kind of non-deterministic data race. The c=
orrupt data region is always less than a page in size (<4096 bytes), it's a=
lways zeros, and it always ends on a page boundary. Because I knew the expe=
cted format of the data, I could also tell that the corrupt data was always=
 at the beginning of a write syscall by our application.

I've attempted to read through the CIFS kernel code involved in this. But I=
've never worked in the VFS/filesystem layers before. And I'm having troubl=
e following / understanding the intricacies of the page cache, page dirtyin=
g/cleaning, and writeback.

My current best guess at what's happening is as follows:
    * Our application writes out a buffer of data to the file on a CIFS sha=
re, this is compressed data that isn't nicely aligned, the data does not en=
d on a page boundary. This is a newly created file that we are writing to, =
so this write extends the files EOF to the end of the newly written data wh=
ich is in the middle of a page in the cache.
    * cifs_writepages() is invoked to write the cached data back to the ser=
ver, it scans the cached pages and prepares to write out all the dirty page=
s (including the final partial page).
    * Our application performs another write. This extends the file and the=
 beginning of this write falls into the end of the previous final partial c=
ached page.
    * cifs_writepages() finishes writing out the dirty pages, including the=
 first portion of what it thought was the final partial page, and marks all=
 pages as clean.
    * On the next invocation of cifs_writepages(), it scans for dirty pages=
 and skips the beginning of the second write because it thinks that page is=
 clean. The following page is a completely new page and is dirty, so it sta=
rts a new write from that page. This would explain why the corruption is al=
ways at the beginning of our application's write and corrects itself at the=
 next page boundary.

I have yet to really prove this, but this type of race between dirty/clean =
pages would explain all the behavior I'm seeing. I'm hoping someone much mo=
re intimately familiar with the CIFS code can help point me in the right di=
rection.

I did try one quick and dirty fix, assuming it was a race I applied the fol=
lowing patch. This added a per inode mutex that completely serialized the c=
ifs_write_begin(), cifs_write_end(), and cifs_writepages() functions. This =
did seem to resolve the data corruption issue, but at the cost of occasiona=
l deadlocks writing to CIFS files.

> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index bbb0ef18d7b8..6e2e273b9838 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1659,6 +1659,7 @@ cifs_init_once(void *inode)
> =20
>  	inode_init_once(&cifsi->netfs.inode);
>  	init_rwsem(&cifsi->lock_sem);
> +	mutex_init(&cifsi->tbl_write_mutex);
 > }
 >=20
>  static int __init
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 43b42eca6780..4af4c5036d81 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1606,6 +1606,17 @@ struct cifsInodeInfo {
>  	bool lease_granted; /* Flag to indicate whether lease or oplock is gran=
ted. */
>  	char *symlink_target;
>  	__u32 reparse_tag;
> +
> +	/* During development we discovered what we believe to be a race condit=
ion
> +	 * in the write caching behavior of cifs. Setting cache=3Dnone solved t=
he
> +	 * issue but with an unacceptable performance hit. The following mutex =
was
> +	 * added to serialize the cifs_write_begin, cifs_write_end, and
> +	 * cifs_writepages functions in file.c. This appears to solve the issue
> +	 * without completely disabling caching.
> +	 *
> +	 * -Mark Whiting (whitingm@opentext.com)
> +	 */
> +	struct mutex tbl_write_mutex;
>  };
> =20
>  static inline struct cifsInodeInfo *
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index cb75b95efb70..d3bc652a7e65 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3085,6 +3085,7 @@ static int cifs_writepages(struct address_space *ma=
pping,
>  {
>  	loff_t start, end;
>  	int ret;
> +	mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> =20
>  	/* We have to be careful as we can end up racing with setattr()
>  	 * truncating the pagecache since the caller doesn't take a lock here
> @@ -3119,6 +3120,7 @@ static int cifs_writepages(struct address_space *ma=
pping,
>  	}
> =20
>  out:
> +	mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>  	return ret;
>  }
> =20
> @@ -3174,6 +3176,8 @@ static int cifs_write_end(struct file *file, struct=
 address_space *mapping,
>  	struct folio *folio =3D page_folio(page);
>  	__u32 pid;
> =20
> +	mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> +
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>  		pid =3D cfile->pid;
>  	else
> @@ -3233,6 +3237,7 @@ static int cifs_write_end(struct file *file, struct=
 address_space *mapping,
>  	/* Indication to update ctime and mtime as close is deferred */
>  	set_bit(CIFS_INO_MODIFIED_ATTR, &CIFS_I(inode)->flags);
> =20
> +	mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>  	return rc;
>  }
> =20
> @@ -4905,6 +4910,7 @@ static int cifs_write_begin(struct file *file, stru=
ct address_space *mapping,
>  	int rc =3D 0;
> =20
>  	cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len);
> +	mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> =20
>  start:
>  	page =3D grab_cache_page_write_begin(mapping, index);
> @@ -4965,6 +4971,7 @@ static int cifs_write_begin(struct file *file, stru=
ct address_space *mapping,
>  		   this will be written out by write_end so is fine */
>  	}
>  out:
> +	mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>  	*pagep =3D page;
>  	return rc;
>  }

Here are some of the log excerpts for one of my test cases. In this file on=
e of the corrupt regions starts at file offset 1,074,214,474 (0x4007364A), =
and was corrupt for 2,486 bytes, ending on a page boundary. First there is =
a section of the log trimmed to just the cifs_write_begin() / cifs_write_en=
d() functions. You can see that there is a write shown at the exact offset/=
length of the corrupted data.

> Mar 25 15:25:39 TX2 kernel: [  124.080900] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074212864 len 1610
> Mar 25 15:25:39 TX2 kernel: [  124.080906] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1074=
212864 with 1610 bytes
> Mar 25 15:25:39 TX2 kernel: [  124.080911] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074214474 len 2486
> Mar 25 15:25:39 TX2 kernel: [  124.080916] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1074=
214474 with 2486 bytes
> Mar 25 15:25:39 TX2 kernel: [  124.080917] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074216960 len 846
> Mar 25 15:25:39 TX2 kernel: [  124.080924] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 00000000880cee03 from pos 1074=
216960 with 846 bytes

Now here's a section of the log trimmed to just the smb2_async_writev() fun=
ction. You can see writes covering the data immediately before and after th=
e corrupted region, but there is no write to the corrupted region. I'm assu=
ming the corrupted region is always zeros because the server is extending a=
nd zero-filling the file to the new write offset after the gap of the missi=
ng write.

> Mar 25 15:25:39 TX2 kernel: [  123.829696] [1635] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1072214016 988260 bytes iter=
=3Df1464
> Mar 25 15:25:39 TX2 kernel: [  124.081016] [1636] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1073201152 1013322 bytes ite=
r=3Df764a
** Missing write: 1073201152 + 1013322 =3D 1074214474 **
> Mar 25 15:25:39 TX2 kernel: [  124.083901] [1636] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1074216960 39564 bytes iter=
=3D9a8c
> Mar 25 15:25:40 TX2 kernel: [  124.340557] [1637] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1074253824 1237843 bytes ite=
r=3D12e353

I can very easily reproduce this with our application. If anyone has any su=
ggestions to try, additional logging / tracing they would like me to perfor=
m, please let me know. I can provide more detailed, full logs if desired, b=
ut they're quite large. I'll continue to read through the code and try to u=
nderstand, if I find anything I will update you.

Thanks,
Mark Whiting

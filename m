From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
 payload
Date: Mon, 14 Aug 2017 19:00:06 +0000
Message-ID: <CY4PR21MB0182AF2A752D333E367F2FC4A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-17-git-send-email-longli@exchange.microsoft.com>
 <20170813102412.GH17287@infradead.org>
 <CY4PR21MB0182366FB8C2EC58B6A77910CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Long Li <longli@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CY4PR21MB0182366FB8C2EC58B6A77910CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> owner@vger.kernel.org] On Behalf Of Long Li
> Sent: Monday, August 14, 2017 2:20 PM
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org
> Subject: RE: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
> payload
>=20
> > > Implement the function to send a SMBD message with no payload. This i=
s
> > required at times when we want to extend credtis to server to have it
> > continue to send data, without sending any actual data payload.
> >
> > Shouldn't this just be implemented as a special case in the version tha=
t posts
> > data?
>=20
> It uses a different packet format "struct smbd_data_transfer_no_data". I =
can
> restructure some common code to share between packet sending functions.

The SMB Direct keepalive is just a Data Transfer Message with no payload
(MS-SMBD section 2.2.3) and the SMB_DIRECT_RESPONSE_REQUESTED flag
possibly set.  I don't see any need to define a special structure to descri=
be this?

Tom.

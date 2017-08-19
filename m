From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 07/37] [CIFS] SMBD: Implement receive buffer for
 handling SMBD response
Date: Sat, 19 Aug 2017 23:41:08 +0000
Message-ID: <MWHPR21MB0190630AFAD0054F60945005CE810@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-8-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB0182912142A7AA71C981E3FDA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CY4PR21MB0182912142A7AA71C981E3FDA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 1:09 PM
> To: Long Li <longli@microsoft.com>; Steve French <sfrench@samba.org>;
> linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Subject: RE: [[PATCH v1] 07/37] [CIFS] SMBD: Implement receive buffer for
> handling SMBD response
>=20
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> > owner@vger.kernel.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:10 PM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>
> > Subject: [[PATCH v1] 07/37] [CIFS] SMBD: Implement receive buffer for
> > handling SMBD response
> >
> > +/*
> > + * Receive buffer operations.
> > + * For each remote send, we need to post a receive. The receive
> > +buffers are
> > + * pre-allocated in advance.
> > + */
>=20
> This approach appears to have been derived from the NFS/RDMA one.
> The SMB protocol operates very differently! It is not a strict request/
> response protocol. Many operations can become asynchronous by the
> server choosing to make a STATUS_PENDING reply. A second reply then
> comes later. The SMB2_CANCEL operation normally has no reply at all.
> And callbacks for oplocks can occur at any time.

I think you misunderstood the receiver buffers. They are posted so the remo=
te peer can post a send. The remote peer's receive credit is calculated bas=
ed on how many receive buffer have been posted.  The code doesn't assume on=
e post_send needs one corresponding post_recv. In practice, receive buffers=
 are posted as soon as possible to extend receive credits to the remote pee=
r.

>=20
> Even within a single request, many replies can be received. For example, =
an
> SMB2_READ response which exceeds your negotiated receive size of 8192.
> These will be fragmented by SMB Direct into a "train" of multiple message=
s,
> which will be logically reassembled by the receiver. Each of them will
> consume a credit.
>=20
> Thanks to SMB Direct crediting, the connection is not failing, but you ar=
e
> undoubtedly spending a lot of time and ping-ponging to re-post receives a=
nd
> allow the message trains to flow. And, because it's never one-to-one, the=
re
> are also unneeded receives posted before and after such exchanges.
>=20
> You need to use SMB Direct crediting to post a more traffic-sensitive poo=
l of
> receives, and simply manage its depth when posting client requests.
> As a start, I'd suggest simply choosing a constant number, approximately
> whatever credit value you actually negotiate with the peer. Then, just
> replenish (re-post) receive buffers as they are completed by the adapter.
> You can get more sophisticated about this strategy later.

The code behaves exactly the same as you described. It uses a constant to d=
ecide how many receive buffer to post. It's not very smart and can be impro=
ved.

>=20
> Tom.
>=20
> > +static struct cifs_rdma_response* get_receive_buffer(struct
> > +cifs_rdma_info
> > *info)
> > +{
> > +       struct cifs_rdma_response *ret =3D NULL;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&info->receive_queue_lock, flags);
> > +       if (!list_empty(&info->receive_queue)) {
> > +               ret =3D list_first_entry(
> > +                       &info->receive_queue,
> > +                       struct cifs_rdma_response, list);
> > +               list_del(&ret->list);
> > +               info->count_receive_buffer--;
> > +               info->count_get_receive_buffer++;
> > +       }
> > +       spin_unlock_irqrestore(&info->receive_queue_lock, flags);
> > +
> > +       return ret;
> > +}
> > +
> > +static void put_receive_buffer(
> > +       struct cifs_rdma_info *info, struct cifs_rdma_response
> > +*response) {
> > +       unsigned long flags;
> > +
> > +       ib_dma_unmap_single(info->id->device, response->sge.addr,
> > +               response->sge.length, DMA_FROM_DEVICE);
> > +
> > +       spin_lock_irqsave(&info->receive_queue_lock, flags);
> > +       list_add_tail(&response->list, &info->receive_queue);
> > +       info->count_receive_buffer++;
> > +       info->count_put_receive_buffer++;
> > +       spin_unlock_irqrestore(&info->receive_queue_lock, flags); }
> > +
> > +static int allocate_receive_buffers(struct cifs_rdma_info *info, int
> > +num_buf) {
> > +       int i;
> > +       struct cifs_rdma_response *response;
> > +
> > +       INIT_LIST_HEAD(&info->receive_queue);
> > +       spin_lock_init(&info->receive_queue_lock);
> > +
> > +       for (i=3D0; i<num_buf; i++) {
> > +               response =3D mempool_alloc(info->response_mempool,
> GFP_KERNEL);
> > +               if (!response)
> > +                       goto allocate_failed;
> > +
> > +               response->info =3D info;
> > +               list_add_tail(&response->list, &info->receive_queue);
> > +               info->count_receive_buffer++;
> > +       }
> > +
> > +       return 0;
> > +
> > +allocate_failed:
> > +       while (!list_empty(&info->receive_queue)) {
> > +               response =3D list_first_entry(
> > +                               &info->receive_queue,
> > +                               struct cifs_rdma_response, list);
> > +               list_del(&response->list);
> > +               info->count_receive_buffer--;
> > +
> > +               mempool_free(response, info->response_mempool);
> > +       }
> > +       return -ENOMEM;
> > +}
> > +
> > +static void destroy_receive_buffers(struct cifs_rdma_info *info) {
> > +       struct cifs_rdma_response *response;
> > +       while ((response =3D get_receive_buffer(info)))
> > +               mempool_free(response, info->response_mempool); }
> > +

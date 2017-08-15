From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle connection
 timer
Date: Tue, 15 Aug 2017 00:10:56 +0000
Message-ID: <CY4PR21MB01827DF9491EC8855ED40929CE8D0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-26-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB018266B47622680566B48575A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
 <CY4PR21MB01829CD26D97DF63CAB08666CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
 <CY4PR21MB01829585183A42669B962B4AA08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR21MB01829585183A42669B962B4AA08C0-kUhI0YP1syo7ifcEnHlXec1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 4:42 PM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>;
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle connection
> timer
>=20
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > Sent: Monday, August 14, 2017 7:30 PM
> > To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French
> > <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux- kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle
> > connection timer
> >
> > [This sender failed our fraud detection checks and may not be who they
> > appear to be. Learn about spoofing at
> > http://aka.ms/LearnAboutSpoofing]
> >
> > > -----Original Message-----
> > > From: Tom Talpey
> > > Sent: Monday, August 14, 2017 2:12 PM
> > > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Steve French
> > > <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux- kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > Subject: RE: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle
> > > connection timer
> > >
> > > > -----Original Message-----
> > > > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Long Li
> > > > Sent: Wednesday, August 2, 2017 4:11 PM
> > > > To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > > Subject: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle
> > > > connection timer
> > > >
> > > > +static int keep_alive_interval =3D 120;
> > >
> > > This is the recommended value, but not the only possibility.
> > >
> > > > @@ -1348,6 +1369,10 @@ struct cifs_rdma_info*
> > > cifs_create_rdma_session(
> > > >         init_waitqueue_head(&info->wait_send_queue);
> > > >         init_waitqueue_head(&info->wait_reassembly_queue);
> > > >
> > > > +       INIT_DELAYED_WORK(&info->idle_timer_work,
> > > idle_connection_timer);
> > > > +       schedule_delayed_work(&info->idle_timer_work,
> > > > +               info->keep_alive_interval*HZ);
> > > > +
> > >
> > > This initialization is ok, but the timer should be rescheduled
> > > (extended) any time any packet is sent. There is no need to perform
> > > keepalives on an active SMB Direct connection.
> >
> > My feeling is that rescheduling on a work queue for every packet is
> > sent is not efficient, especially under heavy conditions.
>=20
> That's not what I was suggesting. Cant the timer simply be re-extended to
> the 120-second interval? I.e. on an active connection, it will never fire
> because it's always advancing.
>=20
> As defined here, it will go off and send a keepalive every 120 seconds. T=
he
> idle_connection_timer() routine unconditionally sends it.
>=20
> >
> > Firing it every 120 seconds doesn't seem to be big waste and may
> > actually save some CPU.
>=20
> Firing the timer, no big deal. Sending the packets and requiring the peer=
 to
> process them too, disagree.

Fair enough. I will fix the code to modify delayed work instead of firing e=
very 120 seconds.

>=20
> Tom.

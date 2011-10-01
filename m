From: "J.P. King" <jpk28-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: CIFS  kernel module bug
Date: Sat, 1 Oct 2011 01:34:44 +0100 (BST)
Message-ID: <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110930234711.GD14147@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Anton will be asleep, so I'll attempt to answer this one.

> What server code is the OES CIFS server running ? I thought Novell CIFS
> services were all Samba based.

We have been told by the people upstairs who run the server that it isn't. 
I have a recollection that it may be a forked version of the samba code, 
but don't rely on my recollections.

Either way it is sitting on top of NSS, a Novell filesystem, which is 
significantly different to "normal" Linux filesystem.  I don't know that
this is the issue, but it is a difference which may affect things 
regardless of the fileserver code.


> Jeremy.

Julian
--
Julian King
Computer Officer, University of Cambridge, Unix Support

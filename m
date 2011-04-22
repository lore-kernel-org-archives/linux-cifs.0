From: Jeff Layton <jlayton@redhat.com>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 22 Apr 2011 07:26:05 -0400
Message-ID: <20110422072605.252eaf14@tlielax.poochiereds.net>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
	<BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
	<BANLkTik2OVULuf1bt2_5J7L6MqmwMQCJ5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTik2OVULuf1bt2_5J7L6MqmwMQCJ5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 22 Apr 2011 14:33:08 +0400
Pavel Shilovsky <piastryyy@gmail.com> wrote:

> 2011/4/15 Steve French <smfrench@gmail.com>:
> > I think nested mid structures (around a base of common mid fields)
> > like the above is going to be the easiest way to handle the differences.
> >
> > I don't understand your PROTOCOL_ID #define though - we
> > identify smb2 vs. cifs via a bool in the tcp server info struct,
> > and presumably if we don't have access to the tcp server
> > info struct we would have to add a field in the base mid
> > (struct mid_q_entry) that indicates smb2 vs. cifs..
> 
> I've just thought about to share tcp_server_info struct between
> different protocol connections. So, we can use cifs and smb2
> connection on the same server and don't keep two socket connections.
> What do you think about to store protocol_id in ses_info rather that
> tcp_server_info?
> 

I don't think that's actually allowed by the protocol. Once a socket
has had a NEGOTIATE done on it, you can't go back and re-do another one.

-- 
Jeff Layton <jlayton@redhat.com>

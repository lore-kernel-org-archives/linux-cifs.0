From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 22 Apr 2011 07:45:26 -0400
Message-ID: <20110422114526.GA31546@infradead.org>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
 <BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
 <BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
 <BANLkTik2OVULuf1bt2_5J7L6MqmwMQCJ5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTik2OVULuf1bt2_5J7L6MqmwMQCJ5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Apr 22, 2011 at 02:33:08PM +0400, Pavel Shilovsky wrote:
> I've just thought about to share tcp_server_info struct between
> different protocol connections. So, we can use cifs and smb2
> connection on the same server and don't keep two socket connections.
> What do you think about to store protocol_id in ses_info rather that
> tcp_server_info?

What about prototyping it either first, and then review an actually
complete smb2 implementation on a branch / as a patchkit do decide
what makes most sense?


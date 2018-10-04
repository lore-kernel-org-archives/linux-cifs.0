From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] dns: Allow the dns resolver to retrieve a
 server set
Date: Thu, 04 Oct 2018 09:42:24 -0700 (PDT)
Message-ID: <20181004.094224.1068745934757143781.davem@davemloft.net>
References: <153865967530.25761.13226347009462917363.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org
To: dhowells@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153865967530.25761.13226347009462917363.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 04 Oct 2018 14:27:55 +0100

> Allow the DNS resolver to retrieve a set of servers and their associated
> addresses, ports, preference and weight ratings.
 ...
> This can then be used to fetch a whole cell's VL-server configuration for
> AFS, for example.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks David.

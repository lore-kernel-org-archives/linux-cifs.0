Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P7DI3S14"
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5C0181
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 04:30:36 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40c09f5a7cfso12507375e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 04:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701693034; x=1702297834; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HuMfu6FSPzoru3F/NYxOWi3OhSfnyZ/3IOLN+7z4hOg=;
        b=P7DI3S14R/SQPAsD73BDGgi9EoLvyH1FPJxXkgZTBnxBq7zQSRa0dg3PFLsK5UD6ZD
         LVa8Y+AvDzlJFuJlelBycKiyHr0qZGhwI+qij/jOVJj5FiaAdBu1dNnf3C5ELu5+Jc+y
         Huet8dm94A4BolTGJuQRNHGyCufj1unVDsgrYPrZ9JhOKGrX4XujM6A8xImRat79ZP9z
         pKPZRZ6KrfmxY1eIzvXbXEtsxMuiS82hJ49sMWIqUOoH38/k1O2BpHhJfhPrAWEscARj
         w1kCIeviS8tKJC5B0c4BElppMuAtSol6MVljBd3badWfHlnf4/WhKlLZ08M4zylLEqVd
         +tsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701693034; x=1702297834;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuMfu6FSPzoru3F/NYxOWi3OhSfnyZ/3IOLN+7z4hOg=;
        b=Q5/LSa/kn95eS5qYFGQu4U0uQoU+7z5oQtV4kL/mD17TT7z38ONrowChhEToJ1kcXB
         MTj8zYyUqWt7zRkEPUbcB6OFPbZKE2MBHICIXEuzR1VZLTJg9Ev1roJD/kPLJiv/UyDK
         owYxj2Nk0Lkr1u9KzpYKYM+E8m9LvAvafCQ/8Z42sW2U3m1kjuyRccEE5ogVuJlkOh5T
         Te0tMK6nmL5xWQLX/apEeO8/9Xh4PpWdZPqO+xORaBOwQ1LCwQ/3CAQArWSKhQth4eoR
         anuEmwflJ8tZ07F7/+ve0wPgKJ5XCGdHDp34YcuJyHxgP2FFWQjpYx16uZ6iqL1cDtkI
         zUeA==
X-Gm-Message-State: AOJu0YwuKqXrS14tlqzPr0362/n+PJG1VH7pHm5hZHtrBqTkxn65wyAW
	fIyZ/uDowPcddbG7p5UMv6g+F9f4VjUqFzwCa9U=
X-Google-Smtp-Source: AGHT+IHP7EOqlknTRHIxMPd2BuSbNioYUlE5cC0MtJnISUT84AE+TKCXTOc74EcG2gy53/6JnnHZnA==
X-Received: by 2002:a05:600c:3b17:b0:40b:3728:badb with SMTP id m23-20020a05600c3b1700b0040b3728badbmr2673928wms.33.1701693034704;
        Mon, 04 Dec 2023 04:30:34 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p17-20020adff211000000b00333332a8d39sm8536801wro.55.2023.12.04.04.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 04:30:34 -0800 (PST)
Date: Mon, 4 Dec 2023 15:30:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: longli@microsoft.com
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] CIFS: SMBD: Implement function to receive data via RDMA
 receive
Message-ID: <896fe25c-f6f4-4ed9-b58d-c922f169ee5f@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Long Li,

The patch f64b78fd1835: "CIFS: SMBD: Implement function to receive
data via RDMA receive" from Nov 22, 2017 (linux-next), leads to the
following Smatch static checker warning:

	fs/smb/client/smbdirect.c:1849 smbd_recv_buf()
	warn: sleeping in atomic context

fs/smb/client/smbdirect.c
    1844 read_rfc1002_done:
    1845                 return data_read;
    1846         }
    1847 
    1848         log_read(INFO, "wait_event on more data\n");
--> 1849         rc = wait_event_interruptible(

This wait is problematic because smbd_recv_page() is holding
kmap_atomic() which disables preemption.

    1850                 info->wait_reassembly_queue,
    1851                 info->reassembly_data_length >= size ||
    1852                         info->transport_status != SMBD_CONNECTED);
    1853         /* Don't return any data if interrupted */
    1854         if (rc)
    1855                 return rc;
    1856 
    1857         if (info->transport_status != SMBD_CONNECTED) {
    1858                 log_read(ERR, "disconnected\n");
    1859                 return -ECONNABORTED;
    1860         }
    1861 
    1862         goto again;
    1863 }

regards,
dan carpenter

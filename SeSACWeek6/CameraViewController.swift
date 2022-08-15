//
//  CameraViewController.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker

class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    
    //UIImagePickerController 1.
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIImagePickerController 2.
        picker.delegate = self
    }
    
    //OpenSource
    //권한은 다 허용하기
    //권한 문구 등도 내부적으로 구현! 실제로 카메라를 쓸 때 권한을 요청
    @IBAction func YPImagePickerButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    //UIImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        //카메라의 유무 분기 처리
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        //피커의 기본 타입을 카메라로 설정
        picker.sourceType = .camera
        //촬영 후 편집이 가능하게 할 것인지
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    //UIImagePickerController
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        //카메라의 유무 분기 처리
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        //피커의 기본 타입을 카메라로 설정
        picker.sourceType = .photoLibrary
        //촬영 후 편집이 가능하게 할 것인지
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        print(#function)
        
    }
    
    //이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답!
    //문자열이 아닌 파일, 이미지, PDF 파일 자체가 그대로 전송 되지 않음. => 텍스트 형태로 인코딩
    //어떤 파일의 종류가 서버에게 전달이 되는지 명시 = Content-Type
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "0d3qC_zWAffwQvIXmONe",
            "X-Naver-Client-Secret": "4NCPw0kB9A",
//            "Content-Type": "multipart/form-data" //라이브러리에 내장되어 있음
        ]
        
        //UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달
        guard let imageData = resultImageView.image?.jpegData(compressionQuality: 0.3) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image") //
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
}

//UIImagePickerController 3.
//네비게이션 컨트롤러를 상속받고 있음
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerController 4. 사진을 선택하거나 카메라 촬영 직후 실행
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본, 편집, 메타 데이터 등 - infoKey로 관리
        
        //촬영 직후 해당 이미지를 편집할 수 있는 화면이 나옴
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
        
    }
    
    //UIImagePickerController 5. 취소 버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
}
